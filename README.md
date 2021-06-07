ddi-xslt
========

This is a collection of xslt-stylesheets for DDI for transformation the metadata to other formats.

# development

Create a new file `docker-compose.override.yml`

Set the enviroment parameters for the XSLT and XML to use in development

```yml
version: "3"
services:
  ddi-xslt-dev:
    environment:
      XSLT: /transformations/dcterms/from-ddi-3.1/ddi_3_1-dcterms.xsl
      XML: /examples/ddi-3.1/example-1.xml
```


GNU Lesser General Public License
=========================

[![GNU LGPL v3.0](https://www.gnu.org/graphics/lgplv3-147x51.png)](https://www.gnu.org/licenses/lgpl-3.0.html)
