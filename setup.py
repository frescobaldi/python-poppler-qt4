#! python

import os

from distutils.core import setup, Extension
import sipdistutils

import PyQt4.pyqtconfig as pyqtconfig
config = pyqtconfig.Configuration()

pyqt_sip_dir = config.pyqt_sip_dir
pyqt_sip_flags = config.pyqt_sip_flags
qt_inc_dir = config.qt_inc_dir

# TODO: use e.g. pkg-config
poppler_inc_dir = "/usr/include/poppler"

# hack to provide our options to sip on its invocation:
class build_ext(sipdistutils.build_ext):
    def _sip_compile(self, sip_bin, source, sbf):
        self.spawn(
            [sip_bin] + self.sip_opts +
            ["-c", self.build_temp,
            "-b", sbf,
            "-I", self._sip_sipfiles_dir(),
            "-I", pyqt_sip_dir,             # find the PyQt4 stuff
            ] + pyqt_sip_flags.split() + [  # use same SIP flags as for PyQt4
            source])


setup(
    name = 'python-poppler-qt4',
    version = '0.1.1',
    description = 'A Python binding to Poppler-Qt4',
    long_description = \
        'A Python binding to Poppler-Qt4 that aims for ' \
        'completeness and for being actively maintained.',
    maintainer = 'Wilbert Berendsen',
    maintainer_email = 'wbsoft@xs4all.nl',
    url = 'http://python-poppler-qt4.googlecode.com/',
    license = 'LGPL',
    classifiers = [
        'Development Status :: 3 - Alpha',
        'Intended Audience :: Developers',
        'License :: OSI Approved :: GNU Library or Lesser General Public License (LGPL)',
        'Operating System :: MacOS :: MacOS X',
        'Operating System :: Microsoft :: Windows',
        'Operating System :: POSIX',
        'Programming Language :: Python',
        'Topic :: Multimedia :: Graphics :: Viewers',
    ],
    ext_modules =  [
        Extension(
            "popplerqt4", ["poppler-qt4.sip"],
            include_dirs = [
                qt_inc_dir,
                os.path.join(qt_inc_dir, 'QtCore'),
                os.path.join(qt_inc_dir, 'QtGui'),
                os.path.join(qt_inc_dir, 'QtXml'),
                poppler_inc_dir,
            ],
            libraries = ["poppler-qt4"],
        ),
    ],
    cmdclass = {'build_ext': build_ext}
)

