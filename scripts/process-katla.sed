# Remove Katla styles
s|<style>.*?</style>||g

# Formatting cleanup
s|<br />||g
s|\\\*|*|g
s|\\_|_|g
s|\\\\|\\|g

# Wrap code blocks in <pre>
s|<code|<pre><code|g
s|</code>|</code></pre>|g

# Replace Katla classes with equivalent highlight.js classes
s|="IdrisKeyword"|="hljs-keyword"|g
s|="IdrisModule"|="hljs-symbol hljs-emphasis"|g
s|="IdrisComment"|="hljs-comment"|g
s|="IdrisFunction"|="hljs-symbol"|g
s|="IdrisBound"|="hljs-name"|g
s|="IdrisData"|="hljs-title"|g
s|="IdrisType"|="hljs-type"|g
s|="IdrisNamespace"|="hljs-symbol hljs-emphasis"|g

# Strip whitespace from beginning of <code> block
s|<code class="IdrisCode">[[:space:]]+|<code class="IdrisCode">|g
s|&nbsp;| |g