#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { FGBIO_DEMOFASTQTOBAM } from '../../../../../modules/nf-core/fgbio/demofastqtobam/main.nf'

workflow test_fgbio_demofastqtobam {
    
    input = [
        [ id:'test', single_end:false ], // meta map
        file(params.test_data['sarscov2']['illumina']['test_paired_end_bam'], checkIfExists: true)
    ]

    FGBIO_DEMOFASTQTOBAM ( input )
}
