#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { GVC } from '../../../../modules/nf-core/gvc/main.nf'

workflow test_gvc {
    /*
    input = [ [ id:'test'], // meta map
              [ file(params.test_data['homo_sapiens']['illumina']['test2_paired_end_recalibrated_sorted_bam'], checkIfExists: true)],
              [ file(params.test_data['homo_sapiens']['illumina']['test2_paired_end_recalibrated_sorted_bam_bai'], checkIfExists: true)],
            ]

    fasta = [ [ id:'genome' ], // meta map
            file(params.test_data['homo_sapiens']['genome']['genome_21_fasta'], checkIfExists: true)
    ]
    fai = [ [ id:'genome' ], // meta map
            file(params.test_data['homo_sapiens']['genome']['genome_21_fasta_fai'], checkIfExists: true)
    ]
    */
   input = [ [ id:'test'], // meta map
             [file("/disk/zhaoyong/database/nf-core_test-datasets/data/genomics/homo_sapiens/illumina/bam/test2.paired_end.recalibrated.sorted.bam",checkIfExists: true)],
             [file("/disk/zhaoyong/database/nf-core_test-datasets/data/genomics/homo_sapiens/illumina/bam/test2.paired_end.recalibrated.sorted.bam.bai",checkIfExists: true)],
           ]
   fasta = [ [ id:'genome' ], // meta map
           file("/disk/zhaoyong/database/nf-core_test-datasets//data/genomics/homo_sapiens/genome/chr21/sequence/genome.fasta",checkIfExists: true)
   ]
   fai = [ [ id:'genome' ], // meta map
           file("/disk/zhaoyong/database/nf-core_test-datasets//data/genomics/homo_sapiens/genome/chr21/sequence/genome.fasta.fai",checkIfExists: true)
   ]
    GVC ( input,fasta,fai,[],[],[],[],false,true,true,false )
}
