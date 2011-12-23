---
title: Longchar sucks. Introducing BigCharacter
shortlink: introducing-bigcharacter
author: Abe Voelker
created_at: 2010-10-12
published: true
kind: article
excerpt: A new Progress / OpenEdge ABL data structure is presented to address some shortcomings with LONGCHAR.
---

Now that I've got your attention, let me say this: <code>LONGCHAR</code> doesn't <em>always</em> suck.  But, it definitely does suck <em>sometimes</em>...

## The Bug

Here's an example.  How long does it take for this code to complete on your system?

<pre class="highlight"><code class="language-abl">
DEF VAR lc AS LONGCHAR NO-UNDO.
DEF VAR i  AS INT      NO-UNDO.

DO i=1 TO 1000000:
  lc = lc + STRING(i).
  IF i MOD 100 EQ 0 THEN
    STATUS DEFAULT STRING(i).
END.
</code></pre>

On the 4-CPU / 8GiB RAM Unix server I ran it on, it took 3 1/2 hours!  It
started rather quickly, but once it hit ~ 100K records it started to slow
down quite a bit.  This issue is documented in ProKB #P101079, and according
to Progress is "expected behavior" due to the `STRING(i)` being
an implicit cast to `LONGCHAR`, which is supposedly a "resource
consuming" operation.  To me, this doesn't really add up, since when you
run the above code, it does go really fast for at least the first 100K records.
If that explanation was true, then wouldn't the operation be consistently slow,
and not start out really fast and then slow down?  Not like the explanation
really matters too much - the operation is slow nonetheless.

This bug is harmful to me mostly due to the heavy use of
`CHAR`-to-`LONGCHAR` appending in my
<a href="http://github.com/abevoelker/ExcelABL">ExcelABL</a> classes.  This is
a needed operation when I have to serialize many objects (Cells) into a flat
chunk of memory (a <code>LONGCHAR</code> in their parent Worksheet).  The
reason for the serialization is because Progress allocates a very large amount
of space for objects, and without flattening them into the smallest amount of
space possible (when the number of objects reaches a certain threshold), one
would run out of memory for even moderately sized Excel Worksheets.
Basically, directly due to this bug, the creation of large Excel documents can
take an unnecessarily long amount of time.

## A Proposed Solution

I have created a new datatype called
<a href="http://github.com/abevoelker/BigCharacter">`BigCharacter`</a> (the
source of which is linked for your convenience) that I hope will address some
of the shortcomings of the `LONGCHAR` datatype.  Even though it will not be
quite a "drop-in" replacement since Progress doesn't allow operator overloading
and there is no garbage collection (well, not in 10.1C anyway), I hope it can
still be considered a useful alternative for some cases.

Here is the same test from above, instead performed using `BigCharacter`:

<pre class="highlight"><code class="language-abl">
DEF VAR objbc AS BigCharacter NO-UNDO.
DEF VAR i     AS INT          NO-UNDO.

objbc = NEW BigCharacter().
DO i=1 TO 1000000:
  objbc:append(STRING(i)).
  IF i MOD 100 EQ 0 THEN
    STATUS DEFAULT STRING(i).
END.

FINALLY:
  IF VALID-OBJECT(objbc) THEN
    DELETE OBJECT objbc NO-ERROR.
END.
</code></pre>

<strong>On my system, this test finished in under <em>two minutes</em>!</strong>

`BigCharacter`'s speed advantage in the above test is due to its strict use of
primitive `CHARACTER` variables at its core, which do not suffer from the
performance penalty of `CHARACTER`-to-`LONGCHAR` append operations referenced
above.  All dynamic allocation of `CHARACTER` data is handled by the class
structure without the user having to know the details.

## Caveats

This code is definitely a work-in-progress and there are a few kinks I have
yet to work out...  I might end up gutting most of the internals and changing
how things work completely.  However, I have tried to structure the
`BigCharacter` public method signatures in a way so that future improvements
should be backwards-compatible with any code that uses the current version
(no re-compile required).  Here are some known and theoretical issues:

* My original, naïve implementation was only a single class which basically
  wrapped `CHARACTER` variables in a temp-table.  Unfortunately, this caused
  errors that prompted me to increase my session `-s` parameter (the stack
  space ceiling).  This has since been corrected with a new design.
* My current implementation is basically a wrapper around the original naïve
  implementation, which can essentially be thought of as a master temp-table
  of `CHARACTER` temp-tables.  Unfortunately, for relatively large amounts
  of data, it prompts the user to increase the session `-l` parameter.  After
  reading Progress Knowledgebase #P116899, I think this might have to do with
  leaving a lot of `CharBlock` `ttChar` buffers open.  A quick fix might be to
  `RELEASE` these buffers when I am done with them.
* Writing to a file/disk is much slower than `LONGCHAR` for relatively large
  amounts of data.  My guess is that the temp-tables are being paged to disk
  without me knowing it, and when I am trying to write their values out to file
  I have to re-read them in to memory before writing them back out to disk
  again.  Since I can't really control how temp-tables are stored internally,
  the only way to get around this is to stop using temp-tables all together. I
  would like to explore using work-tables or indeterminate arrays as an
  alternative; the big advantage of these are that they should stay strictly
  in-memory.
* Progress's hard limit of 32,000 indexes per session.  Since each `CharBlock`
  (and `BigCharacter`) needs its own temp-table, this imposes a limit on the
  maximum size and number of `BigCharacter`s in a session.  Like the above
  issue, the only way to really get around this is to get rid of the usage of
  temp-tables internally in the classes.
