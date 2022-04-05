classdef Banque < handle
%
% La classe Banque represente une institution bancaire comme la Banque de
% Montreal, par exemple.
%
% PROPRIETES:
% - nom: nom de la banque (type: char)
% - numero: numero d'institution (type: char)
% - nbClients: nombre de clients de la banque (type: double)
% - nbComptes: nombre de comptes de la banque (type: double)
% - tabClients: tableau de references vers chacun des clients
% de la banque (type: Client)
% - tabComptes: tableau de references vers chacun des comptes de la banque
% (type: Compte)
%
    properties (Access = private)
    %Initialisation des valeurs
    nom = char.empty();
    numero = char.empty();
    nbClients = 0;
    nbComptes = 0;
    tabClients = Client.empty();
    tabComptes = Compte.empty();
    end

    methods (Access = public)
        function nouvelleBanque = Banque(nomBanque,numInst,tabClientsImp)
        %
        % Cette methode est le constructeur de la classe Banque
        %
        % PARAMÈTRES :
        % - nomBanque : le nom de la banque (type : char).
        % - numInst: le numero de l'institution (type: char).
        % - tabClientsImp: tableau qui correspond a la liste
        % de clients de la banque (type: Client).
        %
        % VALEUR DE RETOUR : une reference vers l'objet cree (type: Banque).
        %
            %Verifie le nombre d'arguments et valide leurs attributs
            if nargin == 2
                validateattributes(nomBanque,{'char'},{'row'});
                validateattributes(numInst,{'char'},{'row'});

                %Assigne le numero et le nom de la nouvelle banque
                nouvelleBanque.numero = numInst;
                nouvelleBanque.nom = nomBanque;

            %Verifie le nombre d'arguments et valide leurs attributs
            elseif nargin ==3
                validateattributes(nomBanque,{'char'},{'row'});
                validateattributes(numInst,{'char'},{'row'});
                validateattributes(tabClientsImp,{'Client'},{'scalar'});
                %Si on recoit un tableau de clients, on assigne les clients
                %a la banque un par un
                for i=1:size(tabClientsImp,2)
                    nouvelleBanque.tabClients = [nouvelleBanque.tabClients;tabClientsImp(i)];
                    nouvelleBanque.nbClients = nouvelleBanque.nbClients+1; 
                end
                
                %Assigne le numero et le nom de la nouvelle banque
                nouvelleBanque.numero = numInst;
                nouvelleBanque.nom = nomBanque;
                                 
            end

        end
        
        %Accesseur qui sert a obtenir le nom d'une Banque
        function [valeurLue] = getNom (objet)
            valeurLue = objet.nom;
        end
    
        %Accesseur qui sert a obtenir le numero d'une Banque
        function [valeurLue] = getNumero (objet)
            valeurLue = objet.numero;
        end

        %Accesseur qui sert a obtenir le nombre de clients d'une Banque
        function [valeurLue] = getNbClient (objet)
            valeurLue = objet.nbClients;
        end

        %Accesseur qui sert a obtenir le nombre de comptes d'une Banque        
        function [valeurLue] = getNbCompte (objet)
            valeurLue = objet.nbComptes;
        end

        function client = ObtenirClient(ref, indiceClient)
            %
            % Methode qui accède a un client specifique pige dans le
            % tableau de clients. 
            %
            % PARAMÈTRES :
            % - ref: reference vers l'objet (type: Client)
            % - indiceClient: correspond a l'indice du client (type:
            % double).
            %
            % RETOUR : reference vers le client (type: Client).
            %

            %Valide les entrees
            validateattributes(indiceClient, {'double'},{'scalar','positive'});
            assert(size(ref.tabClients,2)>=indiceClient);

            %Obtient le client desire selon son indice
            client = ref.tabClients(indiceClient);
        end
        
        function compte = ObtenirCompte(ref, indiceCompte)
            %
            % Methode qui accède a un compte specifique pige dans le
            % tableau de comptes. 
            %
            % PARAMÈTRES :
            % - ref: reference vers l'objet (type: Compte)
            % - indiceCompte: correspond a l'indice du compte (type:
            % double).
            %
            % RETOUR : reference vers le compte (type: Compte).
            %
            %

            %Valide les entrees
            validateattributes(indiceCompte, {'double'},{'scalar','positive'});
            assert(size(ref.tabComptes,2)>=indiceCompte);

            %Obtiet le compte desire selon son indice
            compte = ref.tabComptes(indiceCompte);            
        end

        function AjouterClient(ref, nouvClient)
            %
            % Methode qui ajoute un nouveau client a la liste de clients. 
            %
            % PARAMÈTRES :
            % - ref: reference vers l'objet (type: Banque)
            % - nouvClient: correspond a un nouveau client a ajouter a la
            % liste de clients (type: Client)
            %
            % RETOUR : rien.
            %

            %Valide les entrees et s'assure que le client n'existe pas
            %deja.
            validateattributes(nouvClient,{'Client'},{'scalar'});
            for i=1:size(ref.tabClients,2)
                assert(nouvClient~=ref.tabClients(i),'Ce client existe deja dans la base de donnees.');
            end

            %Ajoute le client au tableau de clients et incremente le nombre
            %de clients
            ref.tabClients = [ref.tabClients,nouvClient];
            ref.nbClients = ref.nbClients + 1;      
        end

        function AjouterCompte(ref, nouvCompte,client)
            %
            % Methode qui ajoute un nouveau compte a la liste de comptes. 
            %
            % PARAMÈTRES :
            % - ref: reference vers l'objet (type: Banque)
            % - nouvCompte: correspond a un nouveau compte a ajouter a la
            % liste de comptes (type: Compte)
            % - client: correspond au proprietaire du compte (type: Client)
            %
            % RETOUR : rien.
            %

            %Valide les entrees et s'assure que le compte n'existe pas deja
            validateattributes(nouvCompte,{'Compte'},{'scalar'});
            validateattributes(client,{'Client'},{'scalar'});
            
            for i=1:size(ref.tabComptes,2)
                assert(nouvCompte~=ref.tabComptes(i),'Ce compte existe deja dans la base de donnees.');
            end
            
            %Assigne un identifiant unique au compte et assigne le compte a
            %un client
            nouvCompte.setIdentifiant(ref.GenererIdentifiantAleatoire());
            nouvCompte.setClient(client);
            client.AjouterCompte(nouvCompte);

            %Ajoute le compte au tableau de comptes et incremente le nombre
            %de comptes
            ref.tabComptes = [ref.tabComptes;nouvCompte];
            ref.nbComptes = ref.nbComptes+1;
        end

        function compteRetour = ObtenirCompteParIdentifiant(ref,identifiant)
            %
            % Methode qui permet d'acceder a un compte par son identifiant. 
            %
            % PARAMÈTRES :
            % - ref: reference vers l'objet (type: Banque)
            % - identifiant: correspond a l'identifiant du compte recherche
            % (type: double)
            %
            % RETOUR : Un Compte dont l'identifiant correspond a celui demande, ou un
            % tableau vide s'il n'est pas trouve.
            %

            %Valide les entrees et initialise le compte de retour comme un
            %compte vide
            validateattributes(identifiant,{'double'},{'scalar'});
            compteTrouve = 0;
  
            %Parcourt le tableau de comptes pour obtenir le compte
            %correspondant a l'identifiant desire
            identifiantComp = num2str(identifiant);
            for i=1:size(ref.tabComptes,1)
                if (strcmp(ref.tabComptes(i).getIdentifiant,identifiantComp))
                    compteTrouve = 1;
                    compteRetour = ref.tabComptes(i);
                end
            end 
            if compteTrouve==0
            compteRetour=[];
            end

        end

        function clientRetour=ObtenirCompteParNumAssSociale(ref, nas)
            %
            % Methode qui permet d'acceder a un compte par son NAS. 
            %
            % PARAMÈTRES :
            % - ref: reference vers l'objet (type: Banque)
            % - nas: correspond au numero d'assurance sociale du compte recherche
            % (type: double)
            %
            % RETOUR : Un Compte dont le NAS correspond a celui demande, ou un
            % tableau vide s'il n'est pas trouve.
            %

            %Valide les entrees et initialise le compte de retour comme un
            %compte vide
            validateattributes(nas,{'char'},{'row'});
            clientRetour = Client.empty();

            %Parcourt le tableau de comptes pour obtenir le compte
            %correspondant au NAS desire
            for i=1:size(ref.tabClients,2)
                if (ref.tabClients(i).getNumeroAssuranceSociale==nas)
                    clientRetour = [clientRetour;ref.tabClients(i)];
                end
            end
        end
    end

    methods (Access = private)
        function nbAleatoire = GenererIdentifiantAleatoire(ref)
            %
            % Methode qui permet de generer un identifiant de compte unique lors de son
            % ajout. 
            %
            % PARAMÈTRES :
            % - ref: reference vers l'objet (type: Compte)
            %
            % RETOUR : un nombre aleatoire correspondant a un identifiant
            % de compte aleatoire (type: char).
            %

            %Initialise la variable qui indique si le compte est unique
            estpasunique = 1;
           
            
            %Initalise le nombre aleatoire comme une chaines de caracteres
            %vide tant que le nombre aleatoire n'est pas unique
            while (estpasunique == 1)
                compteur = 0;
                
                %Stocke un nombre aleatoire de 9 chiffres dans la chaine de
                %caracteres nbAleatoire
                %for j=1:9
                    %nbAleatoire(j) =num2str(randi(9)); 
                %end
                nbAleatoire = num2str(10e6 + randi(9e7 - 1));
                
                %Verifie si le nombre genere est unique
                for i=1:size(ref.tabComptes,2)
                    if strcmp(nbAleatoire,ref.tabComptes(i).getIdentifiant())
                        compteur=compteur+1;
                    end                 
                end

                %Si le nombre genere est unique, on peut sortir de la
                %boucle. Sinon, on recommence.
                if compteur>0
                    estpasunique=1;
                elseif compteur == 0
                    estpasunique=-1;
                end  
            end            
        end
    end
end