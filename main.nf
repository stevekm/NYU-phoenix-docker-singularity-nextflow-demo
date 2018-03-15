Channel.from( ['Sample1','Sample2','Sample3','Sample4'] ).set { samples }

process make_file {
    tag { "${sampleID}" }
    publishDir "${params.output_dir}/make_file", mode: 'copy', overwrite: true
    echo true

    input:
    val(sampleID) from samples

    output:
    file "${sampleID}.txt" into samples_files

    script:
    """
    printf "[make_file]: ${sampleID}\n%s\n%s\n%s\n" "\$(nf_test.sh)" "\$(base_test.sh)" "\$(demo1_test.sh)"
    printf "[make_file]: ${sampleID}\n%s\n%s\n%s\n" "\$(nf_test.sh)" "\$(base_test.sh)" "\$(demo1_test.sh)" > "${sampleID}.txt"
    """
}
samples_files.collectFile(name: "samples_files.txt", storeDir: "${params.output_dir}")
