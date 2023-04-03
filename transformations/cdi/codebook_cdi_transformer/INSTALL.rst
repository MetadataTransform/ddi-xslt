Installing SaxonC
-----------------

Rocky Linux 8
`````````````

1. cd /your/path
2. wget https://www.saxonica.com/download/libsaxon-HEC-setup64-v11.4.zip
3. unzip libsaxon-HEC-setup64-v11.4.zip
4. rm libsaxon-HEC-setup64-v11.4.zip
5. cd libsaxon-HEC-11.4/
6. sudo cp libsaxonhec.so /usr/lib/.
7. sudo cp -r rt /usr/lib/.
8. sudo cp -r saxon-data /usr/lib/.
9. export SAXONC_HOME=/usr/lib
10. cd Saxon.C.API/python-saxon/
11. sudo yum install gcc
12. sudo yum install gcc-c++
13. sudo yum install python3-devel
14. pip3 install --user cython
15. python3 saxon-setup.py build_ext -if
16. export PYTHONPATH=$PYTHONPATH:/your/path/to/libsaxon-HEC-11.4/Saxon.C.API/python-saxon

Ubuntu 20.04
````````````

1. cd /your/path
2. wget https://www.saxonica.com/download/libsaxon-HEC-setup64-v11.4.zip
3. sudo apt-get install unzip
4. unzip libsaxon-HEC-setup64-v11.4.zip
5. rm libsaxon-HEC-setup64-v11.4.zip
6. cd libsaxon-HEC-11.4/
7. sudo cp libsaxonhec.so /usr/lib/.
8. sudo cp -r rt /usr/lib/.
9. sudo cp -r saxon-data /usr/lib/.
10. export SAXONC_HOME=/usr/lib
11. cd Saxon.C.API/python-saxon/
12. sudo apt-get install gcc
13. sudo apt-get install python3-dev
14. sudo apt-get install python3-pip
15. sudo apt install python3.8-venv
16. pip3 install --user cython
17. python3 saxon-setup.py build_ext -if
18. export PYTHONPATH=$PYTHONPATH:/your/path/to/libsaxon-HEC-11.4/Saxon.C.API/python-saxon

Adding environment variable to automatically be exported by login shells
````````````````````````````````````````````````````````````````````````

sudo nano /etc/profile.d/saxonc_pythonpath.sh
export PYTHONPATH=$PYTHONPATH:/your/path/to/libsaxon-HEC-11.4/Saxon.C.API/python-saxon

Installing DDI-C to DDI-CDI Transformer
---------------------------------------

1. Change to repository directory

   cd ddi-xslt/transformations/cdi/codebook_cdi_transformer

2. Create virtualenv

   python3 -m venv ../codebook_cdi_transformer-env

3. Activate virtualenv

   source ../codebook_cdi_transformer-env/bin/activate

4. Install requirements

   pip install -r requirements.txt

5. Install codebook-cdi-transformer

   pip install .
