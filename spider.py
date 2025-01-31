# This file generated by GenerateAutoSpider
from dax import AutoSpider

name = 'RWML'

version = '1.0.1'

exe_lang = 'bash'

inputs = [
    ("src_path", "PATH", "Path to spider helper src"),
    ("fs_path", "PATH", "Path to FreeSurfer install"),
    ("fsl_path", "PATH", "Path to FSL install"),
    ("wml_file", "FILE", "White Matter Lesion map file"),
    ("fs_subj_dir", "DIR", "FreeSurfer subject")]

outputs = [
    ("SCRIPT", "DIR", "SCRIPT"),
    ("mri/stats.txt", "FILE", "STATS"),
    ("rwml.pdf", "FILE", "PDF"),
    ("mri/ROI_wmparc2_lobes.nii.gz", "FILE", "DATA"),
    ("mri/ROI_wmparc2_not.nii.gz", "FILE", "DATA"),
    ("mri/conform_lesion.nii.gz", "FILE", "DATA"),
    ("mri/wmparc2.nii.gz", "FILE", "DATA"),
    ("mri/orig.nii.gz", "FILE", "DATA")
]

code = r"""# Copy FreeSurfer dirs
cp -r ${fs_subj_dir}/*/* ${temp_dir}

# Copy lesion file
cp ${wml_file} ${temp_dir}/mri/input_lesion.nii.gz

# Change directory and run it
cd ${temp_dir}/mri
/bin/bash ${src_path}/main.sh

# make_pdf
convert -size 50x50 xc:transparent -draw "text 0,25 rwml" ${temp_dir}/rwml.pdf
"""

if __name__ == '__main__':
    spider = AutoSpider(
        name,
        inputs,
        outputs,
        code,
        version=version,
        exe_lang=exe_lang,
    )

    spider.go()
