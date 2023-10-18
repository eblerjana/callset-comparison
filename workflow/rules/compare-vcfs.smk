configfile: "config/config.yaml"

callsets = [c for c in config["callset_vcfs"].keys()]


rule vcf_stats:
	input:
		lambda wildcards: config["callset_vcfs"][wildcards.callset]
	output:
		"results/vcf-stats/{callset}.stats"
	conda:
		"../envs/comparison.yml"
	wildcard_constraints:
		callset = "|".join(callsets)
	shell:
		"bcftools view {input} | python3 workflow/scripts/vcf_stats.py > {output}"


def intersect_vcfs_files(wildcards):
	files = []
	for c in callsets:
		files.append("results/vcfs/{callset}-tagged.vcf".format(callset = c))
	return files


rule add_tags:
	input:
		lambda wildcards: config["callset_vcfs"][wildcards.callset]
	output:
		temp("results/vcfs/{callset}-tagged.vcf")
	wildcard_constraints:
		callset = "|".join(callsets)
	conda:
		"../envs/comparison.yml"
	shell:
		"bcftools view {input} | python3 workflow/scripts/add-svtags.py > {output}"


rule intersect_vcfs:
	input:
		intersect_vcfs_files
	output:
		tsv="results/intersection/intersection.tsv",
		vcf="results/intersection/intersection.vcf",
		pdf="results/intersection/intersection.pdf"
	conda:
		"../envs/comparison.yml"
	log:
		"results/intersection/intersection.log"
	params:
		names = callsets
	shell:
		"python3 workflow/scripts/intersect_callsets.py intersect -c {input.callsets} -n {params.names} -t {output.tsv} -v {output.vcf} -p {output.pdf} &> {log}"
