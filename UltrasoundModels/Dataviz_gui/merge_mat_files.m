function merge_mat_files(Amat, Bmat, Outmat)
    copyfile(Amat,Outmat)
    S = load(Bmat);
    save(Outmat,'-struct','S','-append')
end