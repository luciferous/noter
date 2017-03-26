#!/bin/sh

# Render header with substitutions from environment.
cat <<EOF
<!doctype html>
<html lang="$lang">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>$title</title>
    <link href="${prefix}themes/$theme/style.css" rel="stylesheet">
    <link href="${prefix}hk-pyg.css" rel="stylesheet">
    <link rel="alternate" type="application/atom+xml" href="${prefix}feed.atom" title="Atom Feed">
  </head>
  <body>
    <h1>$title</h1>
    <article>
EOF

# Body is sourced from STDIN and indented.
sed 's/^/      /'

# Print footer.
cat <<EOF
    </article>
    $tracking
  </body>
</html>
EOF
