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
      XSLT: /transformations/dcterms/from-ddi-3.2/ddi_3_2-dcterms.xslt
      XML: /examples/ddi-3.2/ZA4586_ddi-I_StudyDescription_3_2.xml
```

Note: In case of compilation error, change End Of Line sequence from CRLF to LF in `run.sh` script.

GNU Lesser General Public License
=========================

[![GNU LGPL v3.0](https://www.gnu.org/graphics/lgplv3-147x51.png)](https://www.gnu.org/licenses/lgpl-3.0.html)
