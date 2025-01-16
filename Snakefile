import os

# Load configuration
configfile: "config/config.yml"

# Paths
RAW_DATA = config["raw_data"]
PROCESSED_DATA = config["processed_data"]
FASTQC_RESULTS = config["fastqc_results"]
TRIMMOMATIC_RESULTS = config["trimmomatic_results"]
MULTIQC_RESULTS = config["multiqc_results"]

# Rule: all
rule all:
    input:
        expand(FASTQC_RESULTS + "{sample}_fastqc.zip", sample="{sample}"),
        expand(TRIMMOMATIC_RESULTS + "{sample}_trimmed.fastq.gz", sample="{sample}"),
        MULTIQC_RESULTS + "multiqc_report.html"

# Rule: FastQC
rule fastqc:
    input:
        RAW_DATA + "{sample}.fastq.gz"
    output:
        zipfile = FASTQC_RESULTS + "{sample}_fastqc.zip",
        html = FASTQC_RESULTS + "{sample}_fastqc.html"
    shell:
        "fastqc -o {FASTQC_RESULTS} {input}"

# Rule: Trimmomatic
rule trimmomatic:
    input:
        RAW_DATA + "{sample}.fastq.gz"
    output:
        trimmed = TRIMMOMATIC_RESULTS + "{sample}_trimmed.fastq.gz"
    params:
        adapter = config["trimmomatic"]["adapter_file"],
        sliding_window = config["trimmomatic"]["sliding_window"],
        minlen = config["trimmomatic"]["minlen"]
    shell:
        "trimmomatic SE -threads 4 {input} {output.trimmed} "
        "ILLUMINACLIP:{params.adapter}:2:30:10 "
        "SLIDINGWINDOW:{params.sliding_window} MINLEN:{params.minlen}"

# Rule: MultiQC
rule multiqc:
    input:
        fastqc_reports = expand(FASTQC_RESULTS + "{sample}_fastqc.zip", sample="{sample}"),
        trimmomatic_logs = expand(TRIMMOMATIC_RESULTS + "{sample}_trimmed.fastq.gz", sample="{sample}")
    output:
        MULTIQC_RESULTS + "multiqc_report.html"
    shell:
        "multiqc -o {MULTIQC_RESULTS} {input.fastqc_reports} {input.trimmomatic_logs}"
