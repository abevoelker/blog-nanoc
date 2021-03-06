--- 
title: Progress / OpenEdge ABL Language and DBMS Considered Harmful
shortlink: progress-openedge-considered-harmful
author: Abe Voelker
created_at: 2010-08-21
updated_at: 2010-10-02
published: true
kind: article
excerpt:
  Having grown weary of the burden of having to code in it, I write a post
  enumerating some reasons why Progress/OpenEdge is a terrible language and
  database system for developing software.
flattr_link: https://flattr.com/thing/447030/Progress-OpenEdge-ABL-Language-and-DBMS-Considered-Harmful
---

I won't go into any detail about how I got the job I currently have programming
in Progress OpenEdge ABL, but suffice to say I knew I was in deep trouble from
the start when most of the documents about the Progress language I read when
learning the language were more focused on "business logic" and how the language
makes things "easy" on the programmer rather than displaying the language's real
raw technical strengths.

The cold chill down my spine that I initially felt upon glancing at the language
documents has since turned into a fiery rage that burns with the intensity of a
thousand suns after having learned it.  I have done my best to make do with the
language's limitations, and I believe I have pushed it to about as far as it can
go without directly linking into external .NET libraries.

I am aware that Progress (later Progress 4GL, now OpenEdge ABL) was really
created as a [DSL](http://en.wikipedia.org/wiki/Domain-specific_language)
to make business data management and reporting simple, and that a lot of the
criticism below is harsh when comparing it to a "real" programming language.
However, the fact that Progress corporation marketed it as a 4GL wizz-bang
language that could do it all instead of the DSL that it really is, means that
it is exempt from such consideration (they preferred to knock down the "3GL"
languages I am contrasting it with below as being less capable!).  This is
especially true considering that any businesses that bought into this hype and
managed to become successful are now stuck with an antiquated, closed language
and database management system, making it impossible to keep up with the latest
advances in technology unless Progress corporation enhances the language to add
features that are not bolted in to the system (which, of course, costs money to
upgrade to version <code>n+1</code>).

I see no reason for a business that needs data
management and reporting to use OpenEdge ABL over any of the well-known (and
free) programming languages and database management systems in the year 2010.
The power of all the external libraries that exist in these languages simply
makes it a no-brainer, and the ability to drop down into something lower-level
and more powerful means that you are not constrained by a domain-specific
language like with OpenEdge ABL.

Finally, I am well aware of the
[negative opinion](http://meyerweb.com/eric/comment/chech.html) some have of
the "considered harmful" type of essay.  I initially tried to think of some
positive attributes of the Progress OpenEdge ABL language and DBMS to include
in order to make this a balanced "positives vs. negatives" essay, but I
honestly couldn't think of any.

So, without further ado is a list of grievances that I have with the language
and database system that I hope will provide reasons for anyone considering
using Progress OpenEdge ABL to ***reconsider!***

<hr />

<div class="zebra-stripe" markdown="1">
### DBMS: No inherent concept of inter-table relationships (i.e. FK).

Progress' database has no concept of inter-table relationships!  I really can't
understate how huge of a weakness I believe this is for a modern
relational database - I would go as far as saying you cannot consider Progress
a modern relational database for this reason.

Consequently, this has major repercussions for the ABL language, whose strength
is its simple integration with database access, because even though doing
simple queries is relatively easy, the "root of the tree" so to speak is
rotten, which kind of makes the fact that you can easily get to the branches
a moot point.

For a database administrator trying to maintain meta information about a very
large database with thousands of tables becomes a Herculean task, because
there is no help from the database internally.  Any table relationship
information must be stored and maintained externally from the database, which
adds overhead and increases the possibility of creating faulty information.

I will mention that in the ABL language there <em>is</em> a querying shortcut,
however, where if you use identical field names (and at least one unique
index) in differing tables you can do

<pre class="highlight"><code class="language-openedge">
FOR EACH order-line OF order
</code></pre>

However, <span style="text-decoration: underline;">do not mistake this for an
underlying concept of inter-table relationships</span>.  This is nothing more
than syntactic sugar for doing simple table joins.
</div>

<div class="zebra-stripe" markdown="1">
### ABL: Division of integers isn't "integer division" (it rounds up!).
Example:

<pre class="highlight"><code class="language-openedge">DEF VAR i AS INT NO-UNDO.
i = 1 / 2.
MESSAGE i. /* Displays '1'! */</code></pre>

Apparently, all types of division are implicitly done as `DECIMAL`, even if you
are dividing two `INTEGER` datatypes and storing the result in another
`INTEGER`.  Therefore, in the example above, the division of 1/2 results in a
`DECIMAL` value of 0.5, which, when assigned to the `INTEGER` datatype, is
rounded up to 1 (!).  The workaround is to do this:

<pre class="highlight"><code class="language-openedge">
TRUNCATE(1 / 2, 0). /* Force integer division (returns '0') */
</code></pre>
</div>

<div class="zebra-stripe" markdown="1">
### ABL: Arrays are 1-based rather than 0-based.
Some might call this a religious argument, but there is a reason that most
programmers start counting from zero.  I'll let
<a href="http://www.cs.utexas.edu/users/EWD/transcriptions/EWD08xx/EWD831.html">
Edsgar Dijkstra take this one</a>.
</div>

<div class="zebra-stripe" markdown="1">
### ABL: Inability to declare a variable as constant.

Using preprocessor directives in many cases can achieve the same result, however,
experience from industry long ago has shown the preprocessor method tends to be
more error-prone (similar to the citation Dijkstra uses in the above 1-based vs
0-based array link).  See <a href="http://www.oualline.com/books.free/style/c06.html#pgfId=239">
<span style="text-decoration: underline;">C Elements of Style</span>, chapter 6</a>
for some examples.

I would also add that it also makes enumerations in object-oriented languages
much better, because a defined constant obeys scoping rules.  For example, you
can create a class called `Color` and define the color `RED` as an integer
enumeration equal to `0xFF0000`; if you define the color `RED` as a public
constant you can then have other classes refer to it like so: `Color::RED`, and
they will simply get the value `0xFF0000`.  Pretty slick!

<div class="alert-message block-message warning">
  <strong>Update 2010-10-02</strong>: Just wanted to point out that the above
  Enum example can be achieved like so:

<pre class="highlight"><code class="language-openedge">
CLASS Color:
  DEFINE PUBLIC STATIC PROPERTY RED AS INTEGER INITIAL 16711680 NO-UNDO
    GET.
    PRIVATE SET.
END CLASS.
</code></pre>

  I recently used a similar method for the
  <a href="http://github.com/abevoelker/OpenEdge-ABL-Stomp-Client">Stomp client
  framework</a>.  I am still hoping for a <code>const</code> keyword for more
  general language use, though.
</div>
</div>

<div class="zebra-stripe" markdown="1">
### ABL: Primitive variables are not very <em>primitive</em>.

<em>My</em> definition of primitive here is a
<a href="http://en.wikipedia.org/wiki/Value_type">value type</a> datatype built
into the language whose behavior cannot be extended by a program and the size
of which is expected to be a fixed size at compile-time, e.g. `INTEGER` or
`LOGICAL`.  I don't really think of `LONGCHAR` as a primitive type.  According
to ProKB #P144589 (my emphasis added):

<blockquote>As for data, such as CHARACTER, LONGCHAR, etc <em><strong>variables
and parameters of any kind</strong></em>, we do not pre-allocate memory for
them, except for the 'coordinates' of the variable or the parameter.
...
The actual data itself is all variable length, whether in memory or in a
record.</blockquote>

To me, that means that the actual stack memory allocated for variables are
<strong>always</strong> pointers to variable-length heap memory.  I can't help
but think that this can have serious performance issues due to the efficiency
differences between stack and heap memory.

I also do not like the fact that anything (even "primitives") can be assigned
a value of `?`, which most ABL programmers who come from other language
backgrounds approximate to be ABL's `NULL` pointer value. This leads to weird
things like how a `LOGICAL` (ABL's boolean datatype) is actually not boolean 
but tertiary - it can have the values `TRUE`, `FALSE`, or `?`. This is actually
how message boxes with "Yes" "No" and "Cancel" buttons in OpenEdge ABL work -
the "Cancel" button assigns the `LOGICAL` variable to `?`.
</div>

<div class="zebra-stripe" markdown="1">
### ABL: Un-optimized language compiler.

When I had to learn Progress for my job, I had been taught from an old manual
that stated that when `ASSIGN`ing to multiple variables sequentially, it is
more efficient to group the assignments into a single `ASSIGN` statement, e.g.

<pre class="highlight"><code class="language-openedge">
ASSIGN i = 0
       j = 1.
</code></pre>

is supposedly more efficient than

<pre class="highlight"><code class="language-openedge">
ASSIGN i = 0.
ASSIGN j = 1.
</code></pre>

I recently was looking at the 10.1C documentation and was surprised to find
that that information is still in there.  I found it hard to believe this is
still an issue, so I even did a test compile in 10.1C and sure enough, the
resulting object code was larger for the two-<code>ASSIGN</code> statement
scenario.

Such a simple thing as this should have been optimized away a long time ago by
the compiler.  The fact that the compiler cannot handle such a simple
optimization leads me to believe that very little is being optimized by it at
all.  This leads to developers always having a faint voice in the back of their
head saying "Will this compile into optimal object code?" which takes away time
and effort from the development process.

<strong>This is one of those things that was an issue at least 10 or 15 years
ago for programmers who code in modern languages.</strong> The fact that I even
have to think about this in the year 2010, quite frankly, is a testament to how
antiquated this language is and sends a message that Progress corporation has
little interest in modernizing its core.  I hope that that doesn't come across
as being too incendiary, but it is one of the issues that I feel very strongly
about.

Just for the heck of it, I also checked to see if the compiler could handle a
somewhat more complex optimization - converting
<a href="http://en.wikipedia.org/wiki/Tail_recursion">tail recursive</a> calls
into iterative:

<pre class="highlight"><code class="language-openedge">
PROCEDURE tailcall:
    DEFINE INPUT PARAMETER ipiNum AS INTEGER NO-UNDO.
    IF ipiNum EQ 99999 THEN
      RETURN.
    ELSE
      RUN tailcall(INPUT ipiNum + 1).
END PROCEDURE.
RUN tailcall(INPUT 1).
</code></pre>

On success, nothing should happen; on failure, the call stack will overflow
(assuming 99999 procedure calls is enough to overflow the call stack).

The result, of course: the stack went "boom".
</div>

<div class="zebra-stripe" markdown="1">
### ABL+DBMS: Un-optimized query compiler resultsets.
A while ago, I had found an interesting scenario where I had a query that
looked like this:

<pre class="highlight"><code class="language-openedge">
FOR EACH table
  WHERE table.field1 EQ "foo"
  AND   (table.field2 EQ "bar" OR table.field2 EQ "baz")
</code></pre>

that was strangely running slow.  I was using an index, and the XREF did show
that it was using the expected index.  I changed the query to look like this:

<pre class="highlight"><code class="language-openedge">
FOR EACH table
  WHERE (table.field1 EQ "foo" AND table.field2 EQ "bar")
     OR (table.field1 EQ "foo" AND table.field2 EQ "baz")
</code></pre>

And presto, the query ran much, much faster, even though mathematically the
two different syntaxes are identical (the XREF listing they produced was
identical, showing they were both using the correct index).  I did spend a
little bit of time looking at Progress' knowledgebase, and supposedly certain
phrasings can cause the resultset (how the DBMS returns results to the client
session) to be broken up differently which is probably the cause of the problem.

However, like the above compiler complaint, this is the year 2010 and not
something the programmer should have to worry about, especially given the
simplicity of the above example and the marketing of Progress ABL as being a
database querying powerhouse (the above example should rather be an example of
how well the language performs in such a scenario).  If I were doing 15 table
joins I would cut it some slack.
</div>

<div class="zebra-stripe" markdown="1">
### ABL: Limited multiprogramming capabilities.

There is no support for forking or threading processes, which allow a much more
lightweight approach (by keeping process access in a single-user context) than
sockets, which is the only method that ABL allows.  Granted, the typical
Progress ABL application probably will not have a use for this for things like
number crunching.  However, forking/threading really shine in networking
applications, which can certainly arise in a data-driven environment like
Progress, where interaction with non-Progress databases may become important.  I
won't get into fine-grained details for those who have never written a network
application, but the ability to have a process to handle incoming requests that
forks or threads a new process for each request is much simpler (and entirely
different) to deal with than a socket-based approach.  Not to mention, the
number of sockets that can be opened is kernel-limited, which I think is
generally around 65,536 (if memory serves).

I do remember reading about a library some people were working on to try and
simulate threads using sockets, which is definitely a valiant effort, but I just
don't think you can achieve the same simplicity (and certainly nowhere near the
same performance without raw language support to hook into the kernel) as a fork
or thread-based approach.
</div>

<div class="zebra-stripe" markdown="1">
### ABL: Lack of useful operators.

Modern languages <a href="http://en.wikipedia.org/wiki/Operators_in_C_and_C%2B%2B">
have operators</a> such as `++`, `--`, `+=`,
`-=`, `*=`, `/=`, `%=`, etc, which
allows for things like `i++` as a shortcut for `i = i + 1`
or `i += 7` as a shortcut for `i = i + 7` or
`cMyString += "foo bar baz"` instead of `cMyString = cMyString +
"foo bar baz"`.

This can get <em>really annoying</em> when your standards dictate using the
`ASSIGN` statement, e.g.

<pre class="highlight"><code class="language-openedge">
ASSIGN cMyString = cMyString + "foo bar baz".
</code></pre>

instead of

<pre class="highlight"><code class="language-openedge">
cMyString += "foo bar baz".
</code></pre>
</div>

<div class="zebra-stripe" markdown="1">
### ABL: Lack of <a href="http://en.wikipedia.org/wiki/Bitwise_operation">bitwise operators and bit-shifting</a> capability.

A couple months ago I had to
implement an object's hashcode; I had planned on hashing a few distinct private
variables and then combining each hashcode together using either a bitwise-and
or an exclusive-or, e.g.

`hashcode(obj) = hashcode(obj.var1) ^ hashcode(obj.var2) ^
hashcode(obj.var3)`

Since Progress doesn't support it, however, I had to do something really
boneheaded, like

`hashcode(string(hashcode(obj.var1)) + string(hashcode(obj.var2)) +
string(hashcode(obj.var3)))`

If it was something important, I probably would have worked out something more
robust, but it got the job done.

Also, although not relevant anymore (due to pipelined processor architectures;
thanks Wikipedia), you can't do fun things like a <a
href="http://en.wikipedia.org/wiki/XOR_swap_algorithm">XOR swap</a> (where you
don't need to allocate a temporary variable for swapping primitives).
</div>

<div class="zebra-stripe" markdown="1">
### ABL: Inconsistent error handling.

Some errors use global
`ERROR-STATUS` handle (trip `ERROR` and push error
message(s) to `GET-MESSAGE`), some methods return a logical and put
error message into `ERROR-STATUS` error queue (retrieved with
`GET-MESSAGE`), some return a logical but don't put error message
into <code>GET-MESSAGE</code> (these are the worst - they push error messages to
stderr and if you don't do this:

<pre class="highlight"><code class="language-openedge">
ASSIGN lSuppressError = methodThrowsError("Foo") NO-ERROR.
</code></pre>

then these will be visible to the
user!).
</div>

<div class="zebra-stripe" markdown="1">
### ABL: `MODULO` using negative LH operator is undefined behavior.

This one is somewhat nit-picky, but it
really bit me one time and was annoying because no warning was produced - it
simply returned weird results.  After checking the documentation, it turns
out that there is a note "The expression must be greater than 0 for MODULO to
return a correct value".

It just seems very silly to me, because modulus is such a simple operation.  It
would be very easy to write a wrapper class around this that checks the
left-hand operator, does a "positive" modulus if the operator is negative, and
then re-applies the negativity after the operation.  This really needs to be
fixed and should have been a long time ago.

Test case:

<pre class="highlight"><code class="language-openedge">
MESSAGE -10 MODULO 3.
</code></pre>
</div>

<div class="zebra-stripe" markdown="1">
### ABL: No native multi-dimensional arrays, e.g. `INTEGER[][]`

This mostly disappointed me because the
language used to be written in C and it would seem like an obvious thing to
inherit.  This isn't the end of the world, though, because the language does
support <code>TEMP-TABLE</code>s, and a similar construct can be created like
so:

<pre class="highlight"><code class="language-openedge">
DEFINE TEMP-TABLE ttThreeDimensionalArray NO-UNDO
  FIELD iX AS INTEGER
  FIELD iY AS INTEGER
  FIELD iZ AS INTEGER
  FIELD cData AS CHARACTER
  INDEX IXPK_XYZ iX iY iZ.
</code></pre>

However, there is a reason that in C++ or Java
one does not always use a <code>Vector</code> or <code>ArrayList</code>: there
is more overhead because of the way the dynamic memory allocation works and the
extra work that goes on behind the scenes to maintain it.  Sometimes you just
want a simple chunk of (preferably stack) memory with no overhead.

The good news is that the work ABL was created for very rarely needs such
performance considerations.
</div>

<div class="zebra-stripe" markdown="1">
### ABL: Temp-tables/Workfiles do not support all datatypes

`LONGCHAR` or `MEMPTR`, specifically. See Progress Error 11406
"Temp-tables and workfiles do not support the LONGCHAR data type." and
Progress Error 3347 "You can define and access a MEMPTR data type only through
program variables."

This would have been useful for me in at least one case, where I wanted to store
a <code>TEMP-TABLE</code> that contained a <code>CHARACTER</code> that
represented a file name and a <code>LONGCHAR</code> that contained the file
contents loaded into memory.  The annoying workaround I use is to wrap these
datatypes in an Object:

<pre class="highlight"><code class="language-openedge">
 /*------------------------------------------------------------------------
    File        : LongcharWrapper.cls
    Purpose     : Wraps a LONGCHAR variable in an Object
    Description : Used in situations where you need to store a LONGCHAR but
                  Progress can't seem to handle it (e.g. in a temp-table)
    Author(s)   : Abe Voelker
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

CLASS LongcharWrapper USE-WIDGET-POOL:

  DEFINE PRIVATE VARIABLE lc AS LONGCHAR NO-UNDO.

  CONSTRUCTOR PUBLIC LongcharWrapper():
    SUPER ().
  END CONSTRUCTOR.

  CONSTRUCTOR PUBLIC LongcharWrapper(INPUT iplc AS LONGCHAR):
    SUPER ().
    ASSIGN lc = iplc.
  END CONSTRUCTOR.

  METHOD PUBLIC LONGCHAR getLongchar():
    RETURN lc.
  END METHOD.

  METHOD PUBLIC VOID setLongchar(INPUT iplc AS LONGCHAR):
    ASSIGN lc = iplc.
  END METHOD.

END CLASS.
</code></pre>
</div>

<div class="zebra-stripe" markdown="1">
### ABL: Poor Unix batch mode error handling.
<span class="label notice">Added 2010-08-31</span>

There are a couple issues that I have with ABL's batch mode error handling when
being ran from Unix.  The first is that the return code for some programs that
should be "error" actually returns "success".  For example, if I run the
following OpenEdge ABL code (which clearly produces an infinite loop that runs
out of stack memory):

<pre class="highlight"><code class="language-openedge">
ROUTINE-LEVEL ON ERROR UNDO, THROW.
RUN p.

PROCEDURE p:
  RUN p.
END PROCEDURE.
</code></pre>

using the following shell script:

<pre class="highlight"><code class="language-bash">
#!/usr/bin/ksh
umask 000

if (mpro -b -p stackboom.p > stdout.txt 2> stderr.txt); then
  echo "success"
else
  echo "fail"
fi
</code></pre>

will output `success` to the shell, even though the output stream is filled with error messages:

<div class="alert-message block-message error">
<code>WARNING: -nb exceeded. Automatically increasing from 90 to 122. (5407)</code><br />
<code>WARNING: -nb exceeded. Automatically increasing from 122 to 154. (5407)</code><br />
<code>WARNING: -nb exceeded. Automatically increasing from 154 to 186. (5407)</code><br />
<code>WARNING: -nb exceeded. Automatically increasing from 186 to 218. (5407)</code><br />
<code>SYSTEM ERROR: -s exceeded. Raising STOP condition and attempting to write stack trace to file 'procore'. Consider increasing -s startup parameter. (5635)</code>
</div>

The second issue I have is that batch mode ABL programs do not write error
output to <code>stderr</code>.  Everything goes to <code>stdout</code>.  I had
initially assumed that any Progress error would go to <code>stderr</code>, so I
tested this using the following code:

<pre class="highlight"><code class="language-openedge">
ROUTINE-LEVEL ON ERROR UNDO, THROW.
UNDO, THROW NEW Progress.Lang.AppError("FooError", 1337).
</code></pre>

which did produce output, however, the output went to <code>stdout</code>.  Upon
further investigation, it turns out that all error messages that are produced
(even system errors) go to <code>stdout</code>.  My guess would be it's another
feature of Progress that tries to oversimplify things in an ill-guided attempt
to make it "easier" on the programmer.  Unfortunately, this type of thing leads
to poor program design, which leads to enormous amounts of technical debt.
</div>

<div class="zebra-stripe" markdown="1">
### OOABL: Objects are *enormous*

I have hit memory allocation of over 1GiB just by creating a couple dozen
objects with small text files (total appended size not greater than 1MiB) loaded
into memory as <code>LONGCHAR</code>s.  This is a big issue because loading a
text file into a <code>LONGCHAR</code> is about the only way to load a file into
memory, short of doing a lot of unnecessary work with <code>MEMPTR</code>s.  I
don't know what else to say other than there is just way too much memory
allocated in the above scenario; I'm not sure if this is strictly to do with the
<code>LONGCHAR</code> datatype or if it is an object-oriented ABL issue.

Dealing with memory in general in object-oriented ABL is annoying because there
is no fine-grained control of the amount of memory to be initialized, nor is
there any way to tell how much memory a class instance will take up when
initialized after completing the class structure (.cls file).  In C++ the
<code>sizeof</code> operator provides this functionality; in Java it is not so
simple, but there is a package that offers the needed functionality -
<code>java.lang.instrument.Instrumentation</code>.

The way I have been measuring object size is to start up a session, record the
starting process memory allocation, run a small program that initializes a large
number of the objects to be measured - say 10,000 or so - and subtract the
starting memory allocation size from the current size (divided by 10,000 of
course).  This is far from an accurate estimate, but it can give a ballpark
figure for the size of an object.

From my own estimates, an Object with only a <code>CHARACTER</code> variable
(and no non-inherited methods) appears to require approximately <strong>21.6
KiB</strong>!  This is much higher than I would have ever expected; it makes me
think of a <code>CHARACTER</code> variable more as allocation for a medium sized
text file than as a replacement for a 'string' datatype like C++/Java offer, of
which I think most programmers expect the starting allocation to typically be
for a paragraph of text or less.
</div>

<div class="zebra-stripe" markdown="1">
### <del><strong>OOABL: Manual memory management (no garbage collection).</strong></del>

<div class="alert-message success">
<strong>Update</strong>: This was implemented in OpenEdge 10.2A
</div>

This is from the "Getting Started:
Object-oriented Programming: Getting Started with Classes, Interfaces, and
Objects" manual, subsection "Managing the object life-cycle" (my emphasis
added):

> **You are responsible for the lifetime of a class
> instance. You must delete the object when it is no longer needed.** If
> the variable used to hold the object reference obtained from the
> `NEW` phrase goes out of scope and the object has not been deleted,
> the object remains in memory even though there is no reference to the object.
> This <strong>can lead to a potential memory leak</strong>, as it can with any
> other dynamically created objects in ABL.
>
> Therefore, as long as you need the object, you must also ensure that you
> maintain an object reference to that object. You can always assign the
> object reference to another variable before it goes out of scope or pass it
> to another procedure, where you can continue to manage the object until you
> finally delete it. 
>
> ### Deleting a class instance 
>
> To avoid memory leaks during the execution of the application, you must
> delete an instantiated object when it is no longer needed. To delete a class
> instance, you must use the `DELETE OBJECT`
> statement.

I do not understand this reasoning in
the slightest; words cannot express how vehemently I loathe this whole concept.
The fact that OpenEdge ABL does not give you fine-grained control of memory
allocation is understandable because it is a domain-specific language that tries
to make things simple for the programmer.  However, to then go on and expect
programmers to always have to free their own memory (otherwise creating memory
leaks) is plain stupidity.  This is simply the worst case scenario of memory
allocation that mixes the weaknesses of Java and C/C++'s different memory
allocation methodologies.
</div>

<div class="zebra-stripe" markdown="1">
### <del><strong>OOABL: No support for abstract methods or classes.</strong></del>

<div class="alert-message success">
<strong>Update</strong>: This was implemented in OpenEdge 10.2B
</div>

Interfaces are nice, but sometimes I want to implement <em>some</em> behavior
in the superclass and stub
out <em>some</em> behavior for the subclass to implement!  This also makes
implementing some design patterns, such as the <a
href="http://en.wikipedia.org/wiki/Template_method_pattern">Template Method
pattern</a>, impossible.  This is a very serious problem for those trying to
make well-structured object-oriented code!
</div>

<div class="zebra-stripe" markdown="1">
### OOABL: No interface inheritance support (sub/superinterfaces).

<div class="alert-message warning">
<strong>Update</strong>: Progress claims this is planned for OpenEdge 11.
</div>

There is no doubt that when ABL implemented object orientation it mostly
copied Java's methodology.  What separates Java from C++ when it comes to
OO is that C++ supports multiple inheritance of classes, while Java decided
to accomplish the same concept by supporting multiple inheritance of interfaces.
Therefore, in Java, a lot of design gets pushed to interfaces.  Interfaces, like
classes, need to be able to support code reuse.  Unfortunately, ABL sucks in this
regard because it doesn't allow interfaces to inherit from eachother, so it
defeats a lot of their utility.

To see an example of good design using interface inheritance, check out the 
how Java's `java.util.Collection` extends `java.lang.Iterable`.

Here's a test case for this behavior:

<pre class="highlight"><code class="language-openedge">
INTERFACE bar: END INTERFACE.
INTERFACE foo EXTENDS bar.
</code></pre>

Which currently (10.2B) returns a Progress error, stopping you dead in your
tracks:

<div class="alert-message block-message error">
  <code>Inheritance is not supported for interfaces. (13046)</code>
</div>
</div>

<div class="zebra-stripe" markdown="1">
### OOABL: Cannot use sockets within a windowed environment.

The problem is that you cannot handle socket reads internally to a class; you
must spawn an external persistent procedure to handle them.  To then be able to
actually read the data from the socket, you must do some type of input blocking
in the class, such as `WAIT-FOR READ-RESPONSE OF hSocket`.  If you
execute that line within a windowed environment, you will get Progress error
2780.  Batch mode processes work fine, however.
</div>

<div class="zebra-stripe" markdown="1">
### OOABL: <code>WAIT-FOR</code> fails inside of methods that do not return <code>VOID</code>.

This is annoying when you are dealing with sockets. The workaround is to put
the `WAIT-FOR` statement inside its own method that returns <code>VOID</code>,
then call that method. If the workaround is so simple, I'm not
sure why the error needs to be thrown in the first place.  See Progress error
5622 for more info.
</div>

<div class="zebra-stripe" markdown="1">
### OOABL: Cannot define a temp-table inside of a method.

The workaround for this is to put the
<code>TEMP-TABLE</code> definition in the main class definition when possible.
However, this will expand the memory size of the object, and is not always a
plausible solution in general.  For instance, I had a situation where I needed
my method to make recursive calls to itself, which meant that I
really needed a <code>TEMP-TABLE</code> that was scoped to each
<code>METHOD</code> call's block.  Otherwise, each recursive call overrides the
class global <code>TEMP-TABLE</code>!  I had to re-do the algorithm iteratively
just because of this weakness.

<div class="alert-message block-message warning">
  <strong>Update 2010-10-02</strong>: Brad Williams pointed out another
  workaround - use a dynamic <code>TEMP-TABLE</code>.

  This will, of course, introduce run-time inefficiencies since the
  <code>TEMP-TABLE</code> definition will not be considered until it is needed
  (no pre-compiling), and also the developer must be sure to clean up after
  him/herself or a memory leak will be created.
</div>
</div>

<div class="zebra-stripe" markdown="1">
### OOABL: <code>CATCH</code>/<code>THROW</code> is not well-implemented.

It does not work as one familiar with the Java/C++ paradigm
would expect.  For example, it would be nice if there were a way to
<code>THROW</code> an error from a class and enforce caller
<code>CATCH</code>ing it at compile-time (in fact there is no <code>TRY</code>
statement at all...).

I'm betting the difficulty is that OpenEdge doesn't resolve these things at
compile-time as it is.  Probably that and there is a lot of
backward-compatibility crap to be maintained.  With that in mind, it would have
been nice if they used different keywords entirely, because it isn't nearly as
useful as C++ or Java's implementations of the same keywords.

It's too bad, because the trip to the salt mines that is writing a
library or framework in ABL could have been made a little easier if this
was done properly.
</div>

<div class="zebra-stripe" markdown="1">
### OOABL: <code>PUBLIC</code> methods cannot access <code>PRIVATE</code> variables or methods using an object reference.

This one comes up a lot when I am writing a getter or setter
for a class.  For instance, if I had a class called Foo, with a private Baz
object variable named <code>objBaz</code> and I wrote a getter like the
following to provide a means to publicly access the Baz:

<pre class="highlight"><code class="language-openedge">
METHOD PUBLIC Foo getBaz():
  RETURN THIS-OBJECT:objBaz.
END METHOD.
</code></pre>

I will get a compiler error:

<div class="alert-message block-message error">
  <code>Cannot reference private member "objBaz" off of an object reference.</code>
</div>

The problem seems to be the <code>THIS-OBJECT</code> reference,
and the (silly) solution is to remove it:

<pre class="highlight"><code class="language-openedge">
METHOD PUBLIC Foo getBaz():
  RETURN objBaz.
END METHOD.
</code></pre>

This compiles fine.  However, it is somewhat common in my experience to
use the same name for the locally-scoped input variable of a setter method
as the name of the class variable, so I am in the habit of being explicit.
In Java, this ambiguity is resolved by using the `this` keyword
to explicitly use the class scope.

The inability of `THIS-OBJECT` to work as expected opens the door to potential
gotcha's when implementing setters:

<pre class="highlight"><code class="language-openedge">
CLASS BadSetter:
  DEFINE PRIVATE VARIABLE cMyChar AS CHAR NO-UNDO.

  CONSTRUCTOR PUBLIC BadSetter(): SUPER(). END CONSTRUCTOR.
    
  METHOD PUBLIC CHARACTER setChar(INPUT cMyChar AS CHAR):
    ASSIGN cMyChar = cMyChar.
  END METHOD.
    
  METHOD PUBLIC CHARACTER getChar():
    RETURN cMyChar.
  END METHOD.
END CLASS.
</code></pre>

Another solution for the getter/setter-specific scenario is to use a
`PROPERTY` instead of a private variable and plain public
getter/setter methods.

<div class="alert-message block-message warning">
  <strong>Update 2010-08-24</strong>: Another example where this could cause
  headaches is with copy constructors.  Consider this example:<br /><br />

  <pre class="highlight"><code class="language-openedge">
CLASS Foo:
  DEF PRIVATE VAR i AS INT NO-UNDO.

  CONSTRUCTOR PUBLIC Foo(): END CONSTRUCTOR.

  /* Copy constructor FAILS: */
  CONSTRUCTOR PUBLIC Foo(INPUT f AS Foo):
    i = f:i.
  END CONSTRUCTOR.
END CLASS.
  </code></pre>
</div>

<div class="alert-message block-message warning">
  <strong>Update 2010-10-02</strong>: Brad Williams has provided an example
  using a <code>PROPERTY</code> that provides correct behavior:<br /><br />

  <pre class="highlight"><code class="language-openedge">
define public property i as integer no-undo get.
  private set.
  </code></pre>

  However, I still think an object should be able to self-reference its private
  variables without needing to change methods to use a <code>PROPERTY</code>.
</div>
</div>

<hr />

<strong>Well, that's it for the list for now.  I will attempt to keep it
up-to-date by adding to and deleting from it as new issues are revealed to me
and old ones are fixed.  Feel free to comment, whether it be to rebut, add to
the list, commiserate, or otherwise!</strong>
