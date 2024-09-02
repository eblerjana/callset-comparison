# SV callset comparisons

Simple pipeline to compare SV calls produced by different SV callers. 

## What the pipeline does

The pipeline computes overlaps between the different callsets based on reciprocal overlap and breakpoint deviations. It creates upset plots to visualize overlaps.

## How to set up

Add paths to callset VCFs to the config file located in `` config/``. If the analysis should be restricted to a specific sample (e.g. in case the VCFs contain multiple samples), you can specify a list of samples in the config file. The analysis will then be run separately for each of these samples. If no samples are given, all variants in the VCF will be used.


## Required input data

VCF files with SV calls. VCFs must be bi-allelic. If they are not, you can transform them to a bi-allelic representation using `` bcftools norm -m -any ``.

## How to run

After the config is set up, run the pipeline using the command `` snakemake -j <nr_of_cores> --use-conda``
