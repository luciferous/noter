#!/bin/sh

# Render header with substitutions from environment.
cat <<EOF
<!doctype html>
<html lang="$lang">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>$title</title>
    <link href="${prefix}theme/style.css" rel="stylesheet">
  </head>
  <body>
    <h1>$title</h1>
EOF

# Body is sourced from STDIN and indented.
sed 's/^/    /'

# Print footer.
cat <<EOF
  </body>
</html>
EOF
