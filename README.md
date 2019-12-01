# workfromhomiesgowest.com

This is a pretty goofy static site set-up that uses sort of a hodge-podge
of tooling along with a Makefile to generate a single stand-alone index.html file.
Much of the content for this page comes from a shared google doc, which is pulled
down and has values extracted and then injected into the index.html during the build
process.  This allows for collaborators to get the data in place in the google docs
sheet, and then those responsible for maintaing the site can readily build and deploy
a new index.html that includes those changes.

## Build/Deploy Tooling

- make
- pandoc
- ruby / bundler
- ruby-sass
- ssh

## Build/Deploy Steps

`make` will run through the whole process and construct a `dist/index.html` file.
Under the hood, this is:

1) Pulling down the .xlsx from google drive
2) buliding main.sass into dist/main.css
3) generating a dist/main.md file that is the basis for all generated docs (and the page)
4) building a dist/index.html and dist/main.pdf which are the consumable forms
   of the document
5) Put everything from dist onto the prod server with SCP


## Deploying

Get your pubkey added to the server by jack and `make deploy`
