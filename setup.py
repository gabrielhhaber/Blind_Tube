from setuptools import setup
from setuptools.extension import Extension
from Cython.Build import cythonize
from Cython.Distutils import build_ext
setup(
	name="Blind Tube",
	version="1.0",
	ext_modules=cythonize(
		[
			Extension(
				"blind_tube._blind_tube",
				[
					"blind_tube/_blind_tube.pyx"
				]
			)
		],
		build_dir="build_cythonize",
		compiler_directives={
			"language_level": "3",
			"always_allow_keywords": True
		}
	),
	cmdclass={"build_ext": build_ext}
)