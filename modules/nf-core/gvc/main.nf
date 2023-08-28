process GVC {
    tag "$meta.id"
    label 'process_single'

    conda "YOUR-TOOL-HERE"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/YOUR-TOOL-HERE':
        'registry.genowis.com/library/gvc_bash:v1.5.6' }"
    containerOptions '--network=host -v /home/:/Genowis  -u $(id -u):$(id -g)'

    input:
    tuple val(meta), path(input), path(input_index)
    tuple val(meta2), path(fasta)
    tuple val(meta3), path(fai)
    path bed
    val region
    val lregion
    path  dbsnp
    val enable_sv
    val enable_indel 
    val enable_snv
    val enable_cnv

    output:
    tuple val(meta), path("*.ghs"), emit: ghs, optional: true
    tuple val(meta), path("*.cov"), emit: cov, optional: true
    tuple val(meta), path("*.pup"), emit: pup, optional: true
    tuple val(meta), path("*.idf"), emit: idf, optional: true
    tuple val(meta), path("*.svf"), emit: svf, optional: true
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def inputs      = input.collect{ "--in $it"}.join(" ")
    def args        = task.ext.args ?: ''
    def prefix      = task.ext.prefix ?: "${meta.id}"
    def fregion_arg = region?"--fregion ${region}":""
    def region_arg  = lregion?"--region ${lregion}":""
    def snp_arg     = enable_snv?"--snp ":""
    def indel_arg   = enable_indel?"--indel ":""
    def cnv_arg     = enable_cnv?"--ghs --cov ":""
    def sv_arg      = enable_sv?"--sv ":""
    def bed_arg     = bed?"--bed ${bed}":""
    def ccd_arg     = bed?"--ccd ${bed}":""
    def dbsnp_arg   = dbsnp?"--dbsnp ${dbsnp}":""


    """
    gvc \\
        ${fregion_arg} \\
        ${region_arg} \\
        ${snp_arg} \\
        ${indel_arg} \\
        ${cnv_arg} \\
        ${sv_arg} \\
        ${bed_arg} \\
        ${ccd_arg} \\
        ${dbsnp_arg} \\
        ${args} \\
        -f ${fasta} \\
        ${inputs} \\
        --out ${prefix}


    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        gvc: \$(gvc -h 2>&1 | sed -n '2,2p' | sed 's/Version:v//')
    END_VERSIONS
    """

    stub:
    def args = task.ext.args ?: ''
    """
    touch ${prefix}.ghs
    touch ${prefix}.cov
    touch ${prefix}.pup
    touch ${prefix}.idf
    touch ${prefix}.svf

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        gvc: \$(gvc -h 2>&1 | sed -n '2,2p' | sed 's/Version:v//')
    END_VERSIONS
    """
}
