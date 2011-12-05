include Nanoc3::Helpers::Blogging
include Nanoc3::Helpers::LinkTo
include Nanoc3::Helpers::Rendering

def production_post_url(shortlink)
  "http://blog.abevoelker.com/#{shortlink}/"
end

def flattr_large(shortlink, flattr_link)
<<-eos
<a class="FlattrButton" style="display:none;" href="#{production_post_url(shortlink)}"></a>
<noscript><a href="#{flattr_link}" target="_blank">
<img src="http://api.flattr.com/button/flattr-badge-large.png" alt="Flattr this" title="Flattr this" border="0" /></a></noscript>
eos
end

def flattr_compact(shortlink, flattr_link)
<<-eos
<a class="FlattrButton" style="display:none;" rev="flattr;button:compact;" href="#{production_post_url(shortlink)}"></a>
<noscript><a href="#{flattr_link}" target="_blank">
<img src="http://api.flattr.com/button/flattr-badge-large.png" alt="Flattr this" title="Flattr this" border="0" /></a></noscript>
eos
end
