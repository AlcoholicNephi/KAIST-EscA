function [ Eff_ideal ] = getEff_ideal(Tci, Pc, Thi, Ph, Tm, m)

if(Tm == -1)
    Eff_ideal = 1;
elseif(Tci > Tm)
    Eff_ideal = 1;
elseif(Thi < Tm)
    Eff_ideal = 1;
else
    
    mc = m;
    mh = 1;
    

    dQ1 = mh * abs(refpropm('H', 'T', Thi, 'P', Ph, 'CO2') - refpropm('H', 'T', Tci, 'P', Ph, 'CO2'));
    dQ2 = mc * abs(refpropm('H', 'T', Thi, 'P', Pc, 'CO2') - refpropm('H', 'T', Tci, 'P', Pc, 'CO2'));
    
    dQ_ideal1 = min(dQ1, dQ2);
    
    dQ_ideal2 = mh * (refpropm('H', 'T', Thi, 'P', Ph, 'CO2') - refpropm('H', 'T', Tm, 'P', Ph, 'CO2')) + mc * (refpropm('H', 'T', Tm, 'P', Pc, 'CO2') - refpropm('H', 'T', Tci, 'P', Pc, 'CO2'));
    
    Eff_ideal = min(dQ_ideal1, dQ_ideal2) / dQ_ideal1;
    
    
end

end

