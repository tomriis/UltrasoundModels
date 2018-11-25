function txfielddb = txfield_to_db(data, fname)
    basename=fname(1:end-8);
    slicexy = strcat(basename,'Slice_xy');
    slicexz = strcat(basename,'Slice_xz');
    sliceyz = strcat(basename, 'Slice_yz');
    
    maxxy = max(max(data.(slicexy)));
    maxxz = max(max(data.(slicexz)));
    maxyz = max(max(data.(sliceyz)));
    
    maxall = max([maxxy, maxxz, maxyz]);
    txfielddb = db(txfield./max(max(txfield)))
    
    
end