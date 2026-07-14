# Remove Line numbers from .idr files
s|<a href="#line[0-9]+" class="IdrisLineNumber">[^<]*</a>||g
s|<div id="line[0-9]+"></div>|<span></span>|g
s|<div id="line[0-9]+">||g
s|</div>||g
