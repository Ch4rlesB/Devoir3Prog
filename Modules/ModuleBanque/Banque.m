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
    tabComptes = Compte.empty();
    end

    methods (Access = public)
        function nouvelleBanque = Banque(nomBanque,numInst, tabClientsImp)
            if nargin == 2
                validateattributes(nomBanque,{'char'},{'row'});
                validateattributes(numInst,{'char'},{'row'});
                nouvelleBanque.numero = numInst;
                nouvelleBanque.nom = nomBanque;
            elseif nargin ==3
                validateattributes(nomBanque,{'char'},{'row'});
                validateattributes(numInst,{'char'},{'row'});
                validateattributes(tabClientsImp,{'Client'},{'scalar'});
                for i=1:size(tabClientsImp,2)
                    nouvelleBanque.tabClients = [nouvelleBanque.tabClients;tabClientsImp(i)];
                    nouvelleBanque.nbClients = nouvelleBanque.nbClients+1; 
                end
                nouvelleBanque.numero = numInst;
                nouvelleBanque.nom = nomBanque;
                                 
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

        function client = ObtenirClient(ref, indiceClient)
            validateattributes(indiceClient, {'double'},{'scalar','positive'});
            assert(size(ref.tabClients,2)>=indiceClient);
            client = ref.tabClients(indiceClient);
        end
        
        function compte = ObtenirCompte(ref, indiceCompte)
            validateattributes(indiceCompte, {'double'},{'scalar','positive'});
            assert(size(ref.tabComptes,2)>=indiceCompte);
            compte = ref.tabComptes(indiceCompte);            
        end

        function AjouterClient(ref, nouvClient)
            validateattributes(nouvClient,{'Client'},{'scalar'});
            for i=1:size(ref.tabClients,2)
                assert(nouvClient~=ref.tabClients(i),'Ce client existe deja dans la base de donnees.');
            end            
            ref.tabClients = [ref.tabClients,nouvClient];
            ref.nbClients = ref.nbClients + 1;      
        end

        function AjouterCompte(ref, nouvCompte,client)
            validateattributes(nouvCompte,{'Compte'},{'scalar'});
            validateattributes(client,{'Client'},{'scalar'});
            for i=1:size(ref.tabComptes,2)
                assert(nouvCompte~=ref.tabComptes(i),'Ce compte existe deja dans la base de donnees.');
            end
            nouvCompte.setIdentifiant(ref.GenererIdentifiantAleatoire());
            nouvCompte.setClient(client);
            client.AjouterCompte(nouvCompte);
            ref.tabComptes = [ref.tabComptes;nouvCompte];
            ref.nbComptes = ref.nbComptes+1;
        end

        function compteRetour = ObtenirCompteParIdentifiant(ref,identifiant)
            validateattributes(identifiant,{'double'},{'scalar'});
            compteRetour = Compte.empty();
            for i=1:size(ref.tabComptes,2)
                if (ref.tabComptes(i).getIdentifiant==identifiant)
                    compteRetour = [compteRetour;ref.tabComptes(i)];
                end
            end           
        end

        function clientRetour=ObtenirCompteParNumAssSociale(ref, nas)
            validateattributes(nas,{'char'},{'row'});
            clientRetour = Client.empty();
            for i=1:size(ref.tabClients,2)
                if (ref.tabClients(i).getNumeroAssuranceSociale==nas)
                    clientRetour = [clientRetour;ref.tabClients(i)];
                end
            end
        end

    end

    methods (Access = private)
        function nbAleatoire = GenererIdentifiantAleatoire(ref)
            estpasunique = 1;
            while (estpasunique == 1)
                compteur = 0;
                nbAleatoire = char.empty();
                for j=1:9
                    nbAleatoire(j) =num2str(randi(9)); 
                end
                for i=1:size(ref.tabComptes,2)
                    if strcmp(nbAleatoire,ref.tabComptes(i).getIdentifiant())
                        compteur=compteur+1;
                    end                 
                    
                end
                if compteur>0
                    estpasunique=1;
                elseif compteur == 0
                    estpasunique=-1;
                end
                
            end            
        end

    end

end