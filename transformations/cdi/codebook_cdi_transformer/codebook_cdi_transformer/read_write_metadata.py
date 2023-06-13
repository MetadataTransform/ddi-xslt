#!/usr/bin/env python3
"""Read/write metadata files"""
import html
import re
import logging
from pathlib import Path
from lxml import etree

logger = logging.getLogger(__name__)


NAMESPACES_DDI = {"c": "ddi:codebook:2_5",
                  "xml": "http://www.w3.org/XML/1998/namespace"}
MALFORMED_HTML_REPLACE = {"<br>": "<br />",
                          "&nbsp;": " "}
TAGS_HTML_STRIP_DDI = ["abstract",
                       "restrctn"]


# Borrowed from kuha_common.document_store.mappings.xmlbase
def element_remove_whitespaces(element):
    """Conversion function to remove extra whitespace from end of element text.

    Iterates element's inner text using
    :meth:`xml.etree.ElementTree.Element.itertext`
    which iterates over this element and all subelements.
    Removes extra whitespaces so paragraphs of text will
    only have one separating whitespace character.

    :param element: Element from which to get text.
    :type element: :obj:`xml.etree.ElementTree.Element`
    :returns: Element's inner text without extra whitespace.
    :rtype: str
    """
    value = ""
    ends_with_space = False
    for text in element.itertext():
        text = " ".join([_p.strip() for _p in text.split("\n")])
        if not ends_with_space and value != "":
            value = value + " " + text.lstrip()
        else:
            value += text.lstrip()
        ends_with_space = text.endswith(" ")
    if ends_with_space:
        value = value.rstrip()
    return value


class ReadWriteMetadata():
    """Read and write metadata in file system using xml format.

    Attributes:
        directory_path (str): Directory for reading and writing metadata files.

    """
    def __init__(self, directory_path):
        self.directory_path = Path(directory_path)

        if not self.directory_path.exists() or not self.directory_path.is_dir():
            self.directory_path.mkdir(parents=True, exist_ok=True)
            logger.info('Directory for xml files created in %s.', self.directory_path)

    def write_record(self, filename, content, directory=None):
        '''
        Writes record on filesystem

        Args:
            filename (str): Name for the file
            content (str): Content to write
            directory (str): Optional directory path if not using the one initialized with the class
        '''
        write_path = Path(directory) if directory is not None else self.directory_path
        if not write_path.exists() or not write_path.is_dir():
            write_path.mkdir(parents=True, exist_ok=True)
            logger.info('Subdirectory for xml files created in %s.', write_path)
        full_write_path = write_path / filename

        with open(full_write_path, 'wb') as write_file:
            write_file.write(content)

    def read_and_yield_records(self, directory=None, subdirectory=None, to_string=False):
        '''
        Reads metadata records in directory and yields them for transforming

        Args:
            directory (str): Optional directory path if not using the one initialized with the class
            subdirectory (str): Optional subdirectory path to limit reading to one subdirectory
            to_string (bool): Returns content as str if True and as lxml.etree._Element if False

        Returns:
            record (dict): All information about the record: name, path on filesystem and content
        '''
        read_path = Path(directory) if directory is not None else self.directory_path
        parser = etree.XMLParser(remove_blank_text=True)
        subdir = subdirectory if subdirectory else '**'
        for file_path in read_path.glob('**/' + subdir + '/*.xml'):
            tree = etree.parse(file_path, parser)
            file_content = etree.tostring(tree, encoding='unicode', pretty_print=True) if to_string else tree
            yield {'name': str(file_path).rsplit('/', maxsplit=1)[-1], 'path': str(file_path), 'content': file_content}

    def strip_html_from_xml_string(self, xml_string, record_id):
        '''
        Unescapes XML string, parses it and removes html from certain elements

        Args:
            xml_string (str): Original XML string before unescaping
            record_id (str): ID of the record for logging errors

        Returns:
            metadata_tree (lxml.etree._Element): XML content after fixing and removing html
        '''
        # Using parser with recover=True means some errors, i.e. broken html, may result in some metadata being left out
        # but it allows parsing to complete despite those errors that we are hopefully fixing anyway
        parser_recover = etree.XMLParser(encoding='utf-8', recover=True)
        xml_string_html_unescape = html.unescape(xml_string)
        # Replace html tags that are known to be malformed in some study xml files
        for tag, value in MALFORMED_HTML_REPLACE.items():
            xml_string_html_unescape = re.sub(tag, value, xml_string_html_unescape, flags=re.I)
        metadata_tree = etree.fromstring(xml_string_html_unescape, parser_recover)

        # Remove html tags
        for tag in TAGS_HTML_STRIP_DDI:
            for possible_html_element in metadata_tree.findall(".//*/c:" + tag + "[@xml:lang='en']",
                                                                namespaces=NAMESPACES_DDI):
                # Recreate clean element and delete previous mess
                text_html_removed_element = etree.SubElement(possible_html_element.getparent(),
                                                                '{' + NAMESPACES_DDI['c'] + '}' + tag)
                text_html_removed_element.attrib['{' + NAMESPACES_DDI['xml'] + '}lang'] = 'en'
                text_html_removed_element.text = element_remove_whitespaces(possible_html_element)
                possible_html_element.getparent().remove(possible_html_element)

        # See if we can now parse file without recover=True
        # Return None if there's still issues
        try:
            xml_string_cleaned = etree.tostring(metadata_tree, encoding='unicode')
            parser_no_recover = etree.XMLParser(encoding='utf-8')
            metadata_tree_cleaned = etree.fromstring(xml_string_cleaned, parser_no_recover)
        except etree.XMLSyntaxError as err:
            logger.error("XML syntax error %s in %s", err, record_id)
            return None
        except BaseException as err:
            logger.error("Unexpected error %s in %s", err, record_id)
            return None
        return metadata_tree_cleaned
