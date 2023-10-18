import sys

for line in sys.stdin:
	if line.startswith('#'):
		print(line.strip())
		continue
	fields = line.strip().split()


	# determine SVLEN and SVTYPE
	ref_allele = fields[3]
	alt_alleles = fields[4].split(',')
	assert len(alt_alleles) == 1

	length = abs(len(ref_allele) - len(alt_alleles[0]))

	if len(ref_allele) < len(alt_alleles[0]):
		svtype = "INS"
	elif len(ref_allele) > len(alt_alleles[0]):
		svtype = "DEL"
	else:
		svtype = "OTHER"
	
	fields[7] = fields[7] + ';SVTYPE=' + svtype
	fields[7] = fields[7] + ';SVLEN=' + str(length)
	print('\t'.join(fields))
