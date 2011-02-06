#! python

project = dict(
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
)

import os
import re
import shlex
import subprocess

from distutils.core import setup, Extension
import sipdistutils

import PyQt4.pyqtconfig
config = PyQt4.pyqtconfig.Configuration()

pyqt_sip_dir = config.pyqt_sip_dir
pyqt_sip_flags = config.pyqt_sip_flags
qt_inc_dir = config.qt_inc_dir


def pkg_config(package, attrs=None, include_only=False):
    """parse the output of pkg-config for a package.
    
    returns the given or a new dictionary with one or more of these keys
    'include_dirs', 'library_dirs', 'libraries'. Every key is a list of paths,
    so that it can be used with distutils Extension objects.
    
    """
    if attrs is None:
        attrs = {}
    cmd = ['pkg-config']
    if include_only:
        cmd += ['--cflags-only-I']
    else:
        cmd += ['--cflags', '--libs']
    cmd.append(package)
    try:
        output = subprocess.Popen(cmd, stdout=subprocess.PIPE).communicate()[0]
    except OSError:
        return attrs
    flag_map = {'-I': 'include_dirs', '-L': 'library_dirs', '-l': 'libraries'}
    for flag in shlex.split(output):
        option, path = flag[:2], flag[2:]
        if option in flag_map:
            l = attrs.setdefault(flag_map[option], [])
            if path not in l:
                l.append(path)
    return attrs

def pkg_config_version(package):
    """Returns the version of the given package as a tuple of ints."""
    cmd = ['pkg-config', '--modversion', package]
    try:
        output = subprocess.Popen(cmd, stdout=subprocess.PIPE).communicate()[0]
        return tuple(map(int, re.findall(r'\d+', output)))
    except OSError:
        sys.stderr.write("Can't determine version of %s\n" % package)
        

ext_args = {
    'include_dirs': [
        qt_inc_dir,
        os.path.join(qt_inc_dir, 'QtCore'),
        os.path.join(qt_inc_dir, 'QtGui'),
        os.path.join(qt_inc_dir, 'QtXml'),
        '/usr/include/poppler',
    ],
}

pkg_config('poppler-qt4', ext_args)

if 'libraries' not in ext_args:
    ext_args['libraries'] = ['poppler-qt4']


# hack to provide our options to sip on its invocation:
class build_ext(sipdistutils.build_ext):
    def _sip_compile(self, sip_bin, source, sbf):
        
        # Disable features if older poppler-qt4 version is found.
        # Default to most recent version supported by our binding.
        # See the defined tags in %Timeline{} in poppler-qt4.sip.
        ver = pkg_config_version('poppler-qt4')
        if not ver or ver < (0, 12, 1):
            tag = 'POPPLER_V0_12_0'
        elif ver < (0, 14, 0):
            tag = 'POPPLER_V0_12_1'
        elif ver < (0, 16, 0):
            tag = 'POPPLER_V0_14_0'
        else:
            tag = 'POPPLER_V0_16_0'
        
        cmd = [sip_bin]
        if hasattr(self, 'sip_opts'):
            cmd += self.sip_opts
        if hasattr(self, '_sip_sipfiles_dir'):
            cmd += ['-I', self._sip_sipfiles_dir()]
        if tag:
            cmd += ['-t', tag]
        cmd += [
            "-c", self.build_temp,
            "-b", sbf,
            "-I", pyqt_sip_dir]             # find the PyQt4 stuff
        cmd += shlex.split(pyqt_sip_flags)  # use same SIP flags as for PyQt4
        cmd.append(source)
        self.spawn(cmd)


setup(
    cmdclass = {'build_ext': build_ext},
    ext_modules = [Extension("popplerqt4", ["poppler-qt4.sip"], **ext_args)],
    **project
)
