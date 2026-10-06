import hashlib, importlib.util, tempfile, unittest
from pathlib import Path
spec=importlib.util.spec_from_file_location('check',Path(__file__).parents[1]/'tools/check_sky130hs_publication.py')
m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
class ManifestTests(unittest.TestCase):
    def test_accept_and_detect_corruption(self):
        with tempfile.TemporaryDirectory() as d:
            r=Path(d);p=r/'a';p.write_bytes(b'original');mfest={'a':{'bytes':8,'sha256':hashlib.sha256(b'original').hexdigest()}}
            self.assertEqual(m.verify_manifest(r,mfest),1)
            p.write_bytes(b'modified')
            with self.assertRaises(ValueError):m.verify_manifest(r,mfest)
    def test_missing(self):
        with tempfile.TemporaryDirectory() as d:
            with self.assertRaises(ValueError):m.verify_manifest(Path(d),{'missing':{'bytes':0,'sha256':''}})
    def test_reject_path_escape(self):
        with tempfile.TemporaryDirectory() as d:
            for path in ('../outside','/etc/passwd'):
                with self.assertRaises(ValueError):m.verify_manifest(Path(d),{path:{'bytes':0,'sha256':''}})
    def test_reject_symlink(self):
        with tempfile.TemporaryDirectory() as d:
            r=Path(d);(r/'a').write_bytes(b'x');(r/'link').symlink_to('a')
            with self.assertRaises(ValueError):m.verify_manifest(r,{'link':{'bytes':1,'sha256':hashlib.sha256(b'x').hexdigest()}})
if __name__=='__main__':unittest.main()
