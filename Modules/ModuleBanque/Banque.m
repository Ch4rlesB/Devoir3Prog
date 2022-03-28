classdef Banque < handle
%
% 
%
    properties (Access = private)
    nom = char.empty();
    numero = char.empty();
    nbClients = 0;
    nbComptes = 0;
    tabClients = Client.empty();
    tabComptes = Comptes.empty();
    end

    methods (Access = public)
        function nouvelleBanque = Banque(nomBanque,numInst, tabClientsImp)
          
        end
        
    end

end