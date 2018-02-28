#!/bin/bash

# Prepare dirs
#RWML=/gpfs21/scratch/boydb1/dev-LST_per_lobe/XXXX_RWML_v1
#mkdir $RWML
#
# Copy FreeSurfer dirs
#FS=/scratch/boydb1/download-FS/PROJ/SUBJ/SESS/PROJ-x-SUBJ-x-SESS-x-FS/DATA/PROJ-x-SUBJ-x-SESS-x-FS
#cp -r $FS/* $RWML
#
# Copy lesion file
#LESION=/scratch/boydb1/download-LST/PROJ/SUBJ/SESS/PROJ-x-SUBJ-x-SESS-x-LST_v1/DATA/b_000_lesion_lbm0_030_rmPROJ-x-SUBJ-x-SESS-x-SCAN.nii.gz
#cp $LESION $RWML/mri/input_lesion.nii.gz
#
# Change directory and run it
#cd $RWML/mri
#===============================================================================
CURPATH=`pwd`
echo $CURPATH
PARENT1=`dirname $CURPATH`
echo $PARENT1
export SUBJECTS_DIR=`dirname $PARENT1`
echo $SUBJECTS_DIR
SUBJECT=`basename $PARENT1`
echo $SUBJECT
#===============================================================================
#export FREESURFER_HOME=/scratch/mcr/freesurfer
#source $FREESURFER_HOME/SetUpFreeSurfer.sh
#===============================================================================
# Make wmparc2

mri_aparc2aseg --s $SUBJECT \
--labelwm --hypo-as-wm --rip-unknown --volmask --ctxseg aparc+aseg.mgz --wmparc-dmax 200 \
--o wmparc2.mgz

mri_convert wmparc2.mgz wmparc2.nii.gz

for T in {1001..1035};do fslmaths wmparc2 -thr $T -uthr $T -bin wmparc2_$T;done
for T in {2001..2035};do fslmaths wmparc2 -thr $T -uthr $T -bin wmparc2_$T;done
for T in {3001..3035};do fslmaths wmparc2 -thr $T -uthr $T -bin wmparc2_$T;done
for T in {4001..4035};do fslmaths wmparc2 -thr $T -uthr $T -bin wmparc2_$T;done
for T in {5001..5002};do fslmaths wmparc2 -thr $T -uthr $T -bin wmparc2_$T;done
for T in {26..28};do fslmaths wmparc2 -thr $T -uthr $T -bin wmparc2_$T;done
for T in {58..60};do fslmaths wmparc2 -thr $T -uthr $T -bin wmparc2_$T;done
for T in {49..54};do fslmaths wmparc2 -thr $T -uthr $T -bin wmparc2_$T;done
for T in {10..18};do fslmaths wmparc2 -thr $T -uthr $T -bin wmparc2_$T;done
for T in {43..44};do fslmaths wmparc2 -thr $T -uthr $T -bin wmparc2_$T;done
for T in {63..63};do fslmaths wmparc2 -thr $T -uthr $T -bin wmparc2_$T;done
for T in {4..5};do fslmaths wmparc2 -thr $T -uthr $T -bin wmparc2_$T;done
for T in {31..31};do fslmaths wmparc2 -thr $T -uthr $T -bin wmparc2_$T;done
#==============================================================================
# Make left temporal lobe
fslmaths \
wmparc2_1001 -add wmparc2_1006 -add wmparc2_1007 -add wmparc2_1009 \
-add wmparc2_1015 -add wmparc2_1016 -add wmparc2_1030 -add wmparc2_1033 \
-add wmparc2_1034 -add wmparc2_3001 -add wmparc2_3006 -add wmparc2_3007 \
-add wmparc2_3009 -add wmparc2_3015 -add wmparc2_3016 \
-add wmparc2_3030 -add wmparc2_3033 -add wmparc2_3034 \
ROI_wmparc2_lh_tlobe

# Make left frontal lobe
fslmaths wmparc2_1003 -add wmparc2_1012 -add wmparc2_1014 -add wmparc2_1017 -add wmparc2_1018 \
-add wmparc2_1019 -add wmparc2_1020 -add wmparc2_1024 -add wmparc2_1027 -add wmparc2_1028 \
-add wmparc2_1032 -add wmparc2_3003 -add wmparc2_3012 -add wmparc2_3014 -add wmparc2_3017 \
-add wmparc2_3018 -add wmparc2_3019 -add wmparc2_3020 -add wmparc2_3024 -add wmparc2_3027 \
-add wmparc2_3028 -add wmparc2_3032 \
ROI_wmparc2_lh_flobe

# Make left parietal lobe
fslmaths \
wmparc2_1008 -add wmparc2_1022 -add wmparc2_1025 -add wmparc2_1029 -add wmparc2_1031 \
-add wmparc2_3008 -add wmparc2_3022 -add wmparc2_3025 -add wmparc2_3029 -add wmparc2_3031 \
ROI_wmparc2_lh_plobe

# Make left occipital lobe
fslmaths \
wmparc2_1005 -add wmparc2_1011 -add wmparc2_1013 -add wmparc2_1021 -add wmparc2_3005 \
-add wmparc2_3011 -add wmparc2_3013 -add wmparc2_3021 \
ROI_wmparc2_lh_olobe

# Make left cingulate lobe
fslmaths \
wmparc2_1002 -add wmparc2_1010 -add wmparc2_1023 -add wmparc2_1026 -add wmparc2_3002 \
-add wmparc2_3010 -add wmparc2_3023 -add wmparc2_3026 \
ROI_wmparc2_lh_cing

# Make left insula
fslmaths \
wmparc2_1035 -add wmparc2_3035 \
ROI_wmparc2_lh_ins

# Make left subgm
fslmaths \
wmparc2_10 -add wmparc2_11 -add wmparc2_12 -add wmparc2_13 -add wmparc2_17 -add wmparc2_18 \
-add wmparc2_26 -add wmparc2_27 -add wmparc2_28 \
ROI_wmparc2_lh_subgm

# Make left vents
fslmaths \
wmparc2_4 -add wmparc2_5 -add wmparc2_31 \
ROI_wmparc2_lh_vent
#==============================================================================
# Make right temporal lobe
fslmaths wmparc2_2001 -add wmparc2_2006 -add wmparc2_2007 \
-add wmparc2_2009 -add wmparc2_2015 -add wmparc2_2016 \
-add wmparc2_2030 -add wmparc2_2033 -add wmparc2_2034 \
-add wmparc2_4001 -add wmparc2_4006 -add wmparc2_4007 \
-add wmparc2_4009 -add wmparc2_4015 -add wmparc2_4016 \
-add wmparc2_4030 -add wmparc2_4033 -add wmparc2_4034 \
ROI_wmparc2_rh_tlobe

# Make right frontal lobe
fslmaths \
wmparc2_2003 -add wmparc2_2012 -add wmparc2_2014 \
-add wmparc2_2017 -add wmparc2_2018 -add wmparc2_2019 \
-add wmparc2_2020 -add wmparc2_2024 -add wmparc2_2027 \
-add wmparc2_2028 -add wmparc2_2032 -add wmparc2_4003 \
-add wmparc2_4012 -add wmparc2_4014 -add wmparc2_4017 \
-add wmparc2_4018 -add wmparc2_4019 -add wmparc2_4020 \
-add wmparc2_4024 -add wmparc2_4027 -add wmparc2_4028 \
-add wmparc2_4032 \
ROI_wmparc2_rh_flobe

# Make right parietal lobe
fslmaths \
wmparc2_2008 -add wmparc2_2022 -add wmparc2_2025 \
-add wmparc2_2029 -add wmparc2_2031 -add wmparc2_4008 \
-add wmparc2_4022 -add wmparc2_4025 -add wmparc2_4029 \
-add wmparc2_4031 \
ROI_wmparc2_rh_plobe

# Make right occipital lobe
fslmaths \
wmparc2_2005 -add wmparc2_2011 -add wmparc2_2013 -add wmparc2_2021 \
-add wmparc2_4005 -add wmparc2_4011 -add wmparc2_4013 -add wmparc2_4021 \
ROI_wmparc2_rh_olobe

# Make right cingulate lobe
fslmaths \
wmparc2_2002 -add wmparc2_2010 -add wmparc2_2023 -add wmparc2_2026 \
-add wmparc2_4002 -add wmparc2_4010 -add wmparc2_4023 -add wmparc2_4026 \
ROI_wmparc2_rh_cing

# Make right insula
fslmaths \
wmparc2_2035 -add wmparc2_4035 \
ROI_wmparc2_rh_ins

# Make right subgm
fslmaths \
wmparc2_49 -add wmparc2_50 -add wmparc2_51 -add wmparc2_52 \
-add wmparc2_53 -add wmparc2_54 \
-add wmparc2_58 -add wmparc2_59 -add wmparc2_60 \
ROI_wmparc2_rh_subgm

# Make right vents
fslmaths \
wmparc2_43 -add wmparc2_44 -add wmparc2_63 \
ROI_wmparc2_rh_vent
#==============================================================================
mri_convert orig.mgz orig.nii.gz
mri_convert rawavg.mgz rawavg.nii.gz
fslcpgeom rawavg.nii.gz input_lesion.nii.gz
mri_convert --conform input_lesion.nii.gz conform_lesion.nii.gz -rt nearest
#==============================================================================
fslmaths wmparc2.nii.gz -bin temp
fslmaths ROI_wmparc2_rh_flobe -mul 1 -add temp temp
fslmaths ROI_wmparc2_lh_flobe -mul 2 -add temp temp
fslmaths ROI_wmparc2_rh_plobe -mul 3 -add temp temp
fslmaths ROI_wmparc2_lh_plobe -mul 4 -add temp temp
fslmaths ROI_wmparc2_rh_tlobe -mul 5 -add temp temp
fslmaths ROI_wmparc2_lh_tlobe -mul 6 -add temp temp
fslmaths ROI_wmparc2_rh_olobe -mul 7 -add temp temp
fslmaths ROI_wmparc2_lh_olobe -mul 8 -add temp temp
fslmaths ROI_wmparc2_rh_cing -mul 9 -add temp temp
fslmaths ROI_wmparc2_lh_cing -mul 10 -add temp temp
fslmaths ROI_wmparc2_rh_ins -mul 11 -add temp temp
fslmaths ROI_wmparc2_lh_ins -mul 12 -add temp temp
fslmaths ROI_wmparc2_rh_subgm -mul 13 -add temp temp
fslmaths ROI_wmparc2_lh_subgm -mul 14 -add temp temp
fslmaths ROI_wmparc2_rh_vent -mul 15 -add temp temp
fslmaths ROI_wmparc2_lh_vent -mul 16 -add temp temp
mv temp.nii.gz ROI_wmparc2_lobes.nii.gz
#==============================================================================
fslmaths ROI_wmparc2_rh_flobe \
-add ROI_wmparc2_lh_flobe \
-add ROI_wmparc2_rh_plobe \
-add ROI_wmparc2_lh_plobe \
-add ROI_wmparc2_rh_tlobe \
-add ROI_wmparc2_lh_tlobe \
-add ROI_wmparc2_rh_olobe \
-add ROI_wmparc2_lh_olobe \
-add ROI_wmparc2_rh_cing \
-add ROI_wmparc2_lh_cing \
-add ROI_wmparc2_rh_ins \
-add ROI_wmparc2_lh_ins \
-add ROI_wmparc2_rh_subgm \
-add ROI_wmparc2_lh_subgm \
-add ROI_wmparc2_rh_vent \
-add ROI_wmparc2_lh_vent \
-binv ROI_wmparc2_not
#==============================================================================
TXT=stats.txt

ROI=(lh_flobe rh_flobe \
lh_plobe rh_plobe \
lh_tlobe rh_tlobe \
lh_olobe rh_olobe \
lh_cing rh_cing \
lh_ins rh_ins \
lh_subgm rh_subgm \
lh_vent rh_vent \
not)

for r in "${ROI[@]}"
do
    echo -n rwml_$r= >> $TXT
    fslstats conform_lesion -k ROI_wmparc2_${r} -V | awk '{printf "%.3f\n", $2/1000.0}' >> $TXT
done
#==============================================================================
echo 'DONE'
