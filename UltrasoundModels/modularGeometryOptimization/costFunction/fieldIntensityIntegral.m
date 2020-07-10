function E = fieldIntensityIntegral(field,dS)
    E = sum(field.^2*dS,'all');%/max(field.^2,[],'all');
end