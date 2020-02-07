function handles = txfield_to_db(handles,max_i)
    data = handles.data(max_i);
    txfield = data.max_hp;
    handles.maxtxfield = max(max(txfield));
    if strcmp(handles.current_params.Slice,'yz') 
        txfield = txfield';
    elseif strcmp(handles.current_params.Slice,'xz')
        txfield = txfield';
    end
    if strcmp(handles.txfield_norm, 'dB')
        txfield = db(txfield./max(max(txfield)));
    elseif strcmp(handles.txfield_norm,'Normalize')
        txfield = txfield;
    end
    handles.txfielddb = txfield;
    
end