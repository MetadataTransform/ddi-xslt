<?xml version='1.0' encoding='utf-8'?>
<!-- Match: / -->
<!-- Value: <fo:root> -->

<!--
  ================================================================
  Xincluded sections:                 Value:
  0: Setup page sizes and layouts     [layout-master-set]
  1: Outline / Bookmarks              [bookmark-tree]
  2: Cover page                       [page-sequence]
  3: Metadata information             [page-sequence] with [table]
  4: Table of contents                [page-sequence]
  5: Overview                         [page-sequence] with [table]
  6: Files Description                [page-sequence]
  7: Variables List                   [page-sequence]
  8: Variable Groups                  [page-sequence]
  9: Variables Description            [page-sequence]
  ================================================================
-->

<xsl:template match="/"
              xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
              xmlns:fo="http://www.w3.org/1999/XSL/Format"
              xmlns:xi="http://www.w3.org/2001/XInclude">
  <fo:root>

    <!-- ================================ -->
    <!-- [0] Setup page size and layout   -->
    <!-- [layout-master-set]              -->
    <!-- ================================ -->

    <fo:layout-master-set>

      <!-- A4 page -->
      <fo:simple-page-master master-name="default-page"
                             page-height="297mm" page-width="210mm"
                             margin-left="20mm" margin-right="20mm"
                             margin-top="20mm" margin-bottom="20mm">

        <fo:region-body region-name="xsl-region-body"
                        margin-top="10mm" margin-bottom="10mm" />

        <fo:region-before region-name="xsl-region-before" extent="10mm" />
        <fo:region-after region-name="xsl-region-after" extent="10mm" />
      </fo:simple-page-master>

    </fo:layout-master-set>

    <!-- ================================ -->
    <!-- [1] to [9]                       -->
    <!-- Other sections                   -->
    <!-- ================================ -->

    <xi:include href='root_template_xincludes/bookmarks.xsl' />
    <xi:include href='root_template_xincludes/cover_page.xsl' />
    <xi:include href='root_template_xincludes/metadata_information.xsl' />
    <xi:include href='root_template_xincludes/table_of_contents.xsl' />
    <xi:include href='root_template_xincludes/overview.xsl' />
    <xi:include href='root_template_xincludes/files_description.xsl' />
    <xi:include href='root_template_xincludes/variables_list.xsl' />
    <xi:include href='root_template_xincludes/variable_groups.xsl' />
    <xi:include href='root_template_xincludes/variables_description.xsl' />

  </fo:root>

</xsl:template>
