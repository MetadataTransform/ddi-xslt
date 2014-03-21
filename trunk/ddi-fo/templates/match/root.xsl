<?xml version='1.0' encoding='utf-8'?>
<!-- root.xsl -->
<!-- ========================== -->
<!-- match: /                   -->
<!-- value: <fo:root>           -->
<!-- ========================== -->

<!-- ============================================================= -->
<!-- Setup page sizes and layouts     [layout-master-set]          -->
<!-- Outline / Bookmarks              [bookmark-tree]              -->
<!-- Cover page                       [page-sequence]              -->
<!-- Metadata information             [page-sequence] with [table] -->
<!-- Table of contents                [page-sequence]              -->
<!-- Overview                         [page-sequence] with [table] -->
<!-- Files Description                [page-sequence]              -->
<!-- Variables List                   [page-sequence]              -->
<!-- Variable Groups                  [page-sequence]              -->
<!-- Variables Description            [page-sequence]              -->
<!-- ============================================================= -->

<xsl:template match="/"
              xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
              xmlns:fo="http://www.w3.org/1999/XSL/Format"
              xmlns:xi="http://www.w3.org/2001/XInclude">
  <fo:root>

    <!-- ================================ -->
    <!-- Setup page size and layout       -->
    <!-- ================================ -->

    <fo:layout-master-set>

      <!-- A4 page -->
      <fo:simple-page-master master-name="A4-page"
        page-height="297mm" page-width="210mm"
        margin-left="20mm" margin-right="20mm"
        margin-top="20mm" margin-bottom="20mm">
        
        <fo:region-body region-name="body" margin-top="10mm" margin-bottom="10mm" />      
        <fo:region-before region-name="before" extent="10mm" />
        <fo:region-after region-name="after" extent="10mm" />
      </fo:simple-page-master>

    </fo:layout-master-set>

    <!-- ================================ -->
    <!-- Other sections                   -->
    <!-- ================================ -->    
    <xi:include href='root_template_xincludes/section-bookmarks.xsl' />
    <xi:include href='root_template_xincludes/section-cover_page.xsl' />
    <xi:include href='root_template_xincludes/section-metadata_information.xsl' />
    <xi:include href='root_template_xincludes/section-table_of_contents.xsl' />
    <xi:include href='root_template_xincludes/section-overview.xsl' />
    <xi:include href='root_template_xincludes/section-files_description.xsl' />
    <xi:include href='root_template_xincludes/section-variables_list.xsl' />
    <xi:include href='root_template_xincludes/section-variable_groups.xsl' />
    <xi:include href='root_template_xincludes/section-variables_description.xsl' />

  </fo:root>

</xsl:template>
