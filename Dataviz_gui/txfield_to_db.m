function txfield = txfield_to_db(handles, fname)
    data = handles.data;
    if strcmp(handles.txfield_norm, 'dB')
        txfield = db(data.(fname)./max(max(data.(fname))));
    elseif strcmp(handles.txfield_norm,'dbmaxall')
        basename=fname(1:end-8);
        slicexy = strcat(basename,'Slice_xy');
        slicexz = strcat(basename,'Slice_xz');
        sliceyz = strcat(basename, 'Slice_yz');

        maxxy = max(max(data.(slicexy)));
        maxxz = max(max(data.(slicexz)));
        maxyz = max(max(data.(sliceyz)));

        maxall = max([maxxy, maxxz, maxyz]);
        txfield = db(data.(fname)./maxall);
    elseif strcmp(handles.txfield_norm, 'Raw')
        txfield = data.(fname);
    elseif strcmp(handles.txfield_norm,'Normalize')
        txfield = data.(fname)./max(max(data.(fname)));
    end
    
    
end