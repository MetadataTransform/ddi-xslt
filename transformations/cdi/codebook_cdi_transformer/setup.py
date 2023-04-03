#!/usr/bin/env python3
# Author(s): Markus Tuominen, Thomas Gilders, Alizera Davoudian
# Copyright 2023 DDI Developers Group
# Licensed under the GNU Lesser General Public License 3.0. See LICENSE.txt for full license.

import setuptools


with open('README.md', 'r') as fh:
    long_description = fh.read()


with open('VERSION', 'r') as fh:
    version = fh.readline().strip()


setuptools.setup(
    name='codebook_cdi_transformer',
    version=version,
    url='',
    description='Transform Codebook to CDI',
    long_description=long_description,
    long_description_content_type='text/markdown',
    license='GNU LGPL v3.0',
    author='Markus Tuominen',
    author_email='markus.tuominen@tuni.fi',
    packages=setuptools.find_packages(),
    install_requires=[
        ''
    ],
    entry_points={'console_scripts': [
        ''
    ]}
)
