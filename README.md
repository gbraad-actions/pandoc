Pandoc Converter
================

Convert documents using Pandoc.
Currently, mostly 'just a test'.

## Usage

```yaml
      - uses: actions/checkout@v4
      
      - name: Convert to HTML
        uses: gbraad-actions/pandoc@main
        with:
          source: "docs/*.md"
          output-format: html
          output-dir: website/content
          extra-args: "--standalone --css=style.css"
      
      - name: Convert to PDF
        uses: gbraad-actions/pandoc@main
        with:
          source: "docs/*.md"
          output-format: pdf
          output-dir: pdf-output
```
