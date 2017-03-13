An extremely minimal static site generator for blogs.

# Hello world

Write your note in [Markdown](https://daringfireball.net/projects/markdown/syntax).

```sh
$ cat > hello-world.md <<EOF
title="Hello!"

This is my first *note*!
EOF
```

Render it.

```sh
$ make
```

Let's have a look. Run `python -m SimpleHTTPServer` and go to http://localhost:8000/hello-world.html.
