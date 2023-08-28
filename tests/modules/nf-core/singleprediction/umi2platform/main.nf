#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { SINGLEPREDICTION_UMI2PLATFORM } from '../../../../../modules/nf-core/singleprediction/umi2platform/main.nf'

workflow test_singleprediction_umi2platform {
    
    input = [
        [ id:'test', single_end:false ], // meta map
        file("/tmp/pytest_workflow_an1t08qe/gvc_test_gvc/output/gvc/test.pup", checkIfExists: true)
    ]
    bam = [ [ id:'test'], // meta map
             [file("/disk/zhaoyong/database/nf-core_test-datasets/data/genomics/homo_sapiens/illumina/bam/test2.paired_end.recalibrated.sorted.bam",checkIfExists: true)],
             [file("/disk/zhaoyong/database/nf-core_test-datasets/data/genomics/homo_sapiens/illumina/bam/test2.paired_end.recalibrated.sorted.bam.bai",checkIfExists: true)],
           ]
   fasta = [ [ id:'genome' ], // meta map
           file("/disk/zhaoyong/database/nf-core_test-datasets/data/genomics/homo_sapiens/genome/chr21/sequence/genome.fasta",checkIfExists: true)
   ]
   fai = [ [ id:'genome' ], // meta map
           file("/disk/zhaoyong/database/nf-core_test-datasets/data/genomics/homo_sapiens/genome/chr21/sequence/genome.fasta.fai",checkIfExists: true)
   ]
   bed= "/disk/zhaoyong/database/nf-core_test-datasets/data/genomics/homo_sapiens/genome/chr21/sequence/multi_intervals.bed"
   type="snv"

    SINGLEPREDICTION_UMI2PLATFORM ( input,bam,fasta,fai,bed,type )
}