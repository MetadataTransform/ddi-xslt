#!/usr/bin/env python3
"""Transform XML metadata"""
import logging
import os
from datetime import date
from lxml import etree
# prettierfier is used to prettify xml but etree could probably do the same with indent when Python is 3.9+
import prettierfier
from pathlib import Path

from .read_write_metadata import ReadWriteMetadata
from saxonc import PySaxonProcessor

logger = logging.getLogger(__name__)


class TransformMetadata():
    '''
    Read XML metadata from file system in DDI 2.5 format and transform it to CDI 1.0

    Attributes:
        xslt_filepath (dict): XSLT file to use for transforming
    '''
    def __init__(self, cdi_directory_path, xslt_filepath=None):
        self.cdi_directory_path = cdi_directory_path
        self.cdi_directory = ReadWriteMetadata(self.cdi_directory_path)
        dirname = os.path.dirname(__file__)
        self.xslt_filepath = os.path.join(dirname, 'ddi25_to_cdi10.xslt')
        if xslt_filepath:
            self.xslt_filepath = os.path.normpath(xslt_filepath)

    def transform_to_cdi(self, filename):
        '''
        Transforms XML with XSLT file by using saxon and also checks for mandatory fields before returning

        Args:
            filename (str): Absolute or relative path to file to transform

        Returns:
            cdi_xml_string (str): CDI XML string
        '''
        with PySaxonProcessor(license=False) as proc:
            # Create new xslt processor and set xslt
            try:
                xsltproc = proc.new_xslt30_processor()
                executable = xsltproc.compile_stylesheet(stylesheet_file=self.xslt_filepath)
                executable.set_result_as_raw_value(True)

                # Set source file
                executable.set_initial_match_selection(file_name=filename)

                # Set example variable
                # example_value = proc.make_string_value("example")
                # executable.set_parameter("example", example_value)

                cdi_xml_string = executable.apply_templates_returning_string()
            except AttributeError as err:
                logger.error("Attribute error: '%s' in %s", err, filename)
                return None
            except BaseException as err:
                logger.error("Unexpected error: '%s' in %s", err, filename)
                return None
            return cdi_xml_string

    def start_transformation(self, codebook_directory):
        '''
        Transforms metadata in Codebook directory to CDI Directorry

        Args:
            codebook_directory (ReadWriteMetadata): Previously initialized class for Codebook xml files
        '''
        # Loop through codebook records
        for metadata in codebook_directory.read_and_yield_records():
            # Try to transform to CDI
            cdi_metadata = self.transform_to_cdi(metadata['path'])
            if cdi_metadata:
                cdi_metadata = prettierfier.prettify_xml(cdi_metadata, indent=2, debug=False)
                cdi_metadata = etree.fromstring(cdi_metadata)
                cdi_metadata = etree.tostring(cdi_metadata, xml_declaration=True, encoding='utf8')
                self.cdi_directory.write_record(metadata['name'], cdi_metadata)
                cdi_metadata = None
                logger.info("Wrote transformed metadata to %s/%s", self.cdi_directory_path, metadata['name'])
