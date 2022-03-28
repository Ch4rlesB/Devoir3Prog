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
            if nargin == 2
                validateattributes(nomBanque,{'char'},{'row'});
                validateattributes(numInst,{'char'},{'row'});                
                tabClientsImp = [nouvelleBanque.AjouterClient,tabClientsImp];
            elseif nargin ==3
                validateattributes(nomBanque,{'char'},{'row'});
                validateattributes(numInst,{'char'},{'row'});
                validateattributes(tabClientsImp,{'Client'},{'scalar'});
                tabClientsImp = [nouvelleBanque.AjouterClient,tabClientsImp];                
            end

        end

        function [valeurLue] = getNom (objet)
            valeurLue = objet.nom;
        end

        function [valeurLue] = getNumero (objet)
            valeurLue = objet.numero;
        end

        function [valeurLue] = getNbClient (objet)
            valeurLue = objet.nbClients;
        end

        function [valeurLue] = getNbCompte (objet)
            valeurLue = objet.nbComptes;
        end

        function ObtenirClient(ref, indiceClient)
            validateattributes(indiceClient, {'double'},{'scalar','positive'});
            assert(size(ref.tabClients,2)<=indiceClient);
            ref.client = ref.tabClients(indiceClient);
        end
        
        function ObtenirCompte(ref, indiceCompte)
            validateattributes(indiceCompte, {'double'},{'scalar','positive'});
            assert(size(ref.tabComptes,2)<=indiceCompte);
            ref.Compte = ref.tabComptes(indiceCompte);            
        end

        function AjouterClient(ref, nouvClient)
            validateattributes(nouvClient,{'Client'},{'scalar'});
            for i=1:size(ref.tabComptes,2)
                assert(nouvClient~=ref.tabComptes(i),'Ce client existe deja dans la base de donnees.');
            end            
            ref.tabClients = [ref.tabClients;nouvClient];
            ref.nbClients = ref.nbClients + 1;      
        end

        function AjouterCompte(ref, nouvCompte,Client)
            validateattributes(nouvCompte,{'Compte'},{'scalar'});
            validateattributes(Client,{'Client'},{'scalar'});
            for i=1:size(ref.tabComptes,2)
                assert(nouvCompte~=ref.compteTab(i),'Ce compte existe deja dans la base de donnees.');
            end
            ref.indentifiant = GenererIdentifiantAleatoire;
            ref.Client = nouvCompte;
            ref.tabClients = [ref.tabClients,nouvCompte];
            ref.nbComptes = ref.nbComptes+1;
        end

        function [compte] = ObtenirCompteParIdentifiant(ref,identifiant)
            validateattributes(identifiant,{'double'},{'scalar'});
            for i=1:size(ref.tabComptes,2)
                if (ref.tabComptes(i)==identifiant)
                    compte = identifiant;
                else
                    compte = [];
                end
            end           
        end

        function [client]=ObtenirCompteParNumAssSociale(ref, nas)
            validateattributes(nas,{'char'},{'scalar'});
            for i=1:size(ref.tabClients,2)
                if (ref.tabClients(i)==nas)
                    client = nas;
                else
                    client = [];
                end
            end
        end

    end
    methods (Access = private)
        function identifiant = GenererIdentifiantAleatoire(ref)
            nb = 1;
            
            while (nb == 1)
                compteur = 0;
                nbAleatoire = randi(9);
                for i=1:size(ref.tabComptes,2)
                    if nbAleatoire==ref.tabComptes(i)
                        compteur=compteur+1;
                    end                 
                    
                end
                if compteur>0
                    nb=1;
                elseif compteur == 0
                    nb=-1;
                end
                
            end
            identifiant = nbAleatoire;            
        end

    end

end