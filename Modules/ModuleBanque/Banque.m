classdef Banque < handle
%
% 
%
    properties (Access = private)
    nom = char.empty();
    numero = char.empty();
    nbClients = 0;
    tabClients = Client.empty();
    end

    methods (Access = public)
        function Banque = Banque()
          
        end
        
    end

end