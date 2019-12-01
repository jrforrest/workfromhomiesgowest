.DEFAULT_GOAL := dist/main.html

dist/main.css: main.sass
	sass main.sass dist/main.css

dist/main.html: main.md dist/main.css
	pandoc main.md -o dist/main.html -c dist/reset.css -c dist/main.css --self-contained --standalone -M title="Work from Homies go West" -c pandoc.css -V title:""

.PHONY: clean
clean:
	rm dist/main.html dist/main.css
