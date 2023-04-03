#!/usr/bin/env python3
"""Read/write/transform metadata"""
import sys
import logging
from pathlib import Path
import configargparse
import yaml
from py12flogging import log_formatter

from .read_write_metadata import ReadWriteMetadata
from .transform_metadata import TransformMetadata

log_formatter.setup_app_logging('codebook_cdi_transformer', loglevel=logging.INFO)

logger = logging.getLogger(__name__)

def parse_all_args():
    '''
    Parse arguments from environment variables, configuration files and/or command line parameters

    Returns:
        options (argparse.Namespace): Parsed arguments
    '''
    parser = configargparse.ArgParser(config_file_parser_class=configargparse.ConfigparserConfigFileParser,
                                      default_config_files=['configuration.yaml'])
    parser.add('-p', '--print_current_config', help='Show keys and values added to namespace and where they come from',
               action='store_true')
    parser.add('-c', '--config', is_config_file=True, help='Config file path')
    parser.add('-v', help='verbose', action='store_true')
    directory_path_group = parser.add_argument_group("Directory paths", "Set paths for writing/reading files")
    directory_path_group.add('-cb', '--codebook_directory_path',
                             help='Path to directory where to write/read harvested metadata files',
                             env_var='XML_TRANSFORMER_CODEBOOK_DIRECTORY_PATH')
    directory_path_group.add('-cdi', '--cdi_directory_path',
                             help='Path to directory where to write/read transformed metadata files',
                             env_var='XML_TRANSFORMER_CDI_DIRECTORY_PATH')
    transform_metadata_group = parser.add_argument_group("CDI", "Settings related to CDI")
    transform_metadata_group.add('-x', '--xslt_path',
                                 help='Path to XSLT file for transforming Codebook to CDI',
                                 env_var='XML_TRANSFORMER_XSLT_PATH', type=yaml.safe_load)
    options = parser.parse_args()

    if options.print_current_config:
        print(options)
        print("----------")
        print(parser.format_values())
        sys.exit(0)

    return options


def main():
    '''
    Transform and write metadata to filesystem in DDI-CDI format

    Returns:
        0 (int): Returns 0 on success
    '''
    args = parse_all_args()
    codebook_directory = ReadWriteMetadata(args.codebook_directory_path)

    # Could get things like registrationAuthorityIdentifier or versionIdentifier from config instead of DDI-C xml
    # and pass them to TransformMetadata here for adding them to DDI-CDI xml
    transform = TransformMetadata(args.cdi_directory_path, args.xslt_path)
    transform.start_transformation(codebook_directory)

    return 0


if __name__ == '__main__':
    sys.exit(main())
