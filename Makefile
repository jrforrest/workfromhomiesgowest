.DEFAULT_GOAL := dist/index.html

dist/main.xlsx:
	curl >dist/main.xlsx https://docs.google.com/spreadsheets/d/1XEsU0J-w0kKRPvEREg_w0LhJ9Quqj-op9lMjLe8gRYs/export?format=xlsx

dist/main.css: main.sass
	sass main.sass dist/main.css

dist/main.md: dist/main.xlsx
	bundle exec ruby ./generate_markdown.rb dist/main.xlsx ./main.md.erb dist/main.md

dist/index.html: dist/main.md dist/main.css
	pandoc main.md -o dist/index.html -c dist/reset.css -c dist/main.css --self-contained --standalone -M title="Work from Homies go West" -c pandoc.css -V title:""

.PHONY: deploy
deploy: dist/index.html
	scp dist/index.html root@workfromhomiesgowest.com:/var/www/html/

.PHONY: clean
clean:
	rm -f dist/main.xlsx dist/main.md dist/index.html dist/main.css

.PHONY: refetch_data
refetch_data: clean_data dist/main.xlsx

.PHONY: clean_data
clean_data:
	rm -f dist/main.xlsx
