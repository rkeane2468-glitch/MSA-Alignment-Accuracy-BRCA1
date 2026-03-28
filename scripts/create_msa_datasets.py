# -*- coding: utf-8 -*-
"""
@author: rkean
"""
import os
from Bio import SeqIO
from Bio.Seq import Seq
from Bio.SeqRecord import SeqRecord

os.chdir(r"C:\Users\rkean\Downloads\MSA project\data\raw_sequence")

record = SeqIO.read("brca1.sequence.fasta", "fasta")
original_seq = str(record.seq)
seq_len = len(original_seq)

print("Loaded sequence:", record.id)
print("Sequence length:", seq_len)

input_dir ="generated_inputs"
ref_dir = "reference_alignments"

os.makedirs(input_dir, exist_ok=True)
os.makedirs(ref_dir, exist_ok=True)

def generate_dataset(original_seq, deletion_size, mode, num_mutants=10, min_start=40):

    seq_len = len(original_seq)

    if mode =="overlapping":

        step = max(1, deletion_size // 3)
    elif mode =="non_overlapping":

        step = deletion_size + 20
    else:
        raise ValueError("mode must be 'overlapping' or 'non_overlapping'")

    starts = [min_start + pos * step for pos in range(num_mutants)]

    for s in starts:
        if s + deletion_size > seq_len:
            raise ValueError(
                f"{mode} deletion size {deletion_size} runs past sequence end. "
                f"Try fewer mutants or a smaller min_start.")

    input_records = []
    input_records.append(
        SeqRecord(Seq(original_seq), id="original", description="full_length"))

    for pos, start in enumerate(starts, start=1):
        deleted_seq = original_seq[:start] + original_seq[start + deletion_size:]
        input_records.append(
            SeqRecord(
                Seq(deleted_seq),
                id=f"mutant_{pos}",
                description=""))

    ref_records = []
    ref_records.append(
            SeqRecord(Seq(original_seq), id="original", description="reference_alignment"))

    for pos, start in enumerate(starts, start=1):
        gapped_seq = (
            original_seq[:start]
            + "-" * deletion_size
            + original_seq[start + deletion_size:])
        ref_records.append(
            SeqRecord(
                Seq(gapped_seq),
                id=f"mutant_{pos}",
                description=f"{mode}_aligned_deletion_start={start}_size={deletion_size}"))

    if mode =="overlapping":
        short_mode = "ol"
    else:
        short_mode = "nonol"

    input_file = os.path.join(input_dir, f"BRCA1_{short_mode}_del{deletion_size}_input.fasta")
    ref_file = os.path.join(ref_dir, f"BRCA1_{short_mode}_del{deletion_size}_reference.fasta")

    SeqIO.write(input_records, input_file, "fasta")
    SeqIO.write(ref_records, ref_file, "fasta")

    print(f"\nCreated dataset: {mode}, deletion size {deletion_size}")
    print("Deletion starts:", starts)
    print("Input file:", input_file)
    print("Reference file:", ref_file)

    print("Input lengths:")
    for r in input_records:
        print(r.id, len(r.seq))

    print("Reference lengths:")
    for r in ref_records:
        print(r.id, len(r.seq))

generate_dataset(original_seq, deletion_size=10, mode="overlapping")
generate_dataset(original_seq, deletion_size=30, mode="overlapping")
generate_dataset(original_seq, deletion_size=10, mode="non_overlapping")
generate_dataset(original_seq, deletion_size=30, mode="non_overlapping")

print("\nAll datasets created successfully.")
