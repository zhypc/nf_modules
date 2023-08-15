process SINGLEPREDICTION_V1 {
    tag "$meta.id"
    label 'process_single'

    conda "YOUR-TOOL-HERE"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/YOUR-TOOL-HERE':
        'registry.genowis.com/library/single_sample_feature2vcf:v2.2.3' }"

    input:
    tuple val(meta), path(input)
    tuple val(meta2), path(bam),path(bam_index)
    tuple val(meta3), path(fasta)
    tuple val(meta4), path(fai)
    path bed
    val type

    output:
    tuple val(meta), path("*.vcf"), emit: vcf
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def VERSION="2.2.3"
    """
    sh /usr/bin/single_sample_feature2vcf.sh \\
        $input \\
        $bed \\
        $type \\
        $bam \\
        $fasta \\
        $prefix \\
        ${prefix}.${type}.vcf \\
        $task.cpus \\
        $args 


    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        single_sample_feature2vcf: $VERSION
    END_VERSIONS
    """

    stub:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def VERSION="2.2.3"
    """
    touch ${prefix}.bam

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        single_sample_feature2vcf: $VERSION
    """
}
