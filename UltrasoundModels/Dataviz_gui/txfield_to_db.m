function handles = txfield_to_db(handles, fname)
    data = handles.data;
    txfield = data.(fname);
    handles.maxtxfield = max(max(txfield));
        
    txfield = fliplr(txfield);
      
    if strcmp(handles.txfield_norm, 'dB')
        txfield = db(txfield./max(max(txfield)));
    elseif strcmp(handles.txfield_norm,'dbmaxall')
        basename=fname(1:end-8);
        slicexy = strcat(basename,'Slice_xy');
        slicexz = strcat(basename,'Slice_xz');
        sliceyz = strcat(basename, 'Slice_yz');

        maxxy = max(max(data.(slicexy)));
        maxxz = max(max(data.(slicexz)));
        maxyz = max(max(data.(sliceyz)));

        maxall = max([maxxy, maxxz, maxyz]);
        txfield = db(txfield./maxall);
    elseif strcmp(handles.txfield_norm,'Normalize')
        txfield = txfield./max(max(txfield));
    end
    handles.txfielddb = txfield;
    
end