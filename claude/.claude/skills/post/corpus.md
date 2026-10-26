# Corpus

Lu à l'étape 4 de `post`, avant d'écrire. Les posts de Thomas tels qu'il les a écrits, avant correction (fautes comprises : on imite la voix, pas l'orthographe). Seule retouche : dans le post Undo, la blague fausse « 17 + 10 = 40 » est retirée. Le plus récent en premier. Ajouter un post quand il en écrit un nouveau à lui. Le post du 10-15 (« L'IA a mal fait TON travail ») est introuvable.

## 10-26 · Réactivité face aux failles, sa fin à lui (dirigeant ; le début est un brouillon /post)

La newsletter du vendredi ? Trop tard. Le collègue qui "suit un peu Twitter" ? Pas fiable.

Et moi ? Honnêtement, je n'ai pas la réponse. Il y a tellement de bruit en ce moment (chaque faille a maintenant son nom, son site et sa vidéo) que trier le grave du reste devient un métier. Et meme juste lire devier une activité, la nuit, le week end ca ne s'arrete pas.

Et, oh boy, c'est pas fini, ce n'est que le début.

Vous le gérez comment, vous ?

## 10-25 · L'accès prod (dev, question)

Il y a un truc avec l'IA que je ne comprends pas.

79 % des équipes donnent à leurs agents IA un accès au cloud.
Parmi elles, 26 % leur ouvrent aussi la production.

Et là, je suis ... sur mon petit popotin.

Chez moi, la règle est simple : mon IA ne se connecte jamais à un serveur et ne lit jamais un secret.

L'IA m'écrit la commande, je valide que c'est ok et c'est moi qui la lance.

Ça me coûte 10 secondes.

Alors sincèrement, je ne comprends pas, le risque est si grand et le gain si faible.

Pourquoi vous faites ca ? Comment pouvez vous avoir confiance ?

## 10-24 · Managers vs devs (dirigeant ; peu d'intérêt)

38 % des managers trouvent le code écrit par l'IA plus facile à déboguer.

Chez les développeurs, c'est l'inverse : 51 % trouvent le code humain plus simple à déboguer.

Même entreprise, même IA, deux perceptions complètement différentes.

En tout cas c'est ce que montre l'étude localstack 2026.

Ce qui est frappant au delà des chiffres c'est cette perceptions décalées.
On le voit à plein d'endroit, sur l'efficacité de l'IA, s'il faut recruter plus ou non, si les devs doivent se restreindre à shipper du code ou non.

Et on observe très souvent des décisions qui se prennent sans l'avis de l'équipe.

Consultez vos équipes,

C'est pas dur à faire, c'est eux qui utilisent et ce sont eux qui savent. Le résultat variera d'une équipe à l'autre ainsi que les décisions.

## 10-23 · PHP, Node, et aujourd'hui Ruby (actualité, court)

Ce qui s'est passé avec PHP. Ce n'est probablement que le début d'une assez longue série.

Il y a eu node aussi en même temps (même si ca à fait moins de bruit).

Et aujourd'hui ruby.

claude -p update the app to ruby 4.0.9. CF : [lien]

C'est tipar

## 10-23 · Comme promis, l'article (étude démontée)

Comme promis, l'article dont je parlais ce matin.

Les devs passeraient 17 h par semaine à déboguer, contre 10 h à coder.

Donc l'IA ferait gagner du temps à l'écriture et le perdrait au débogage (en tout cas c'est ce qu'on y lit).

Et puis, pour changer mes habitudes, je l'ai lue (oui parce que bon hein voilà).

1. Ca ne dit pas si les bugs sont induits par le code produit par les IA ou si elle provient d'une meilleure détection grâce aux IA.
2. Ca ne parle pas des processus mis en place et le niveau de maturité de ceux qui l'utilise.
3. Les heures ne sont pas mesurées. Les répondants donnent un pourcentage de leur temps, que l'étude convertit sur une semaine "supposée de 40 h".
4. Il n'y a aucune mesure d'avant l'IA. Pratique pour comparer.
5. L'étude est financée par un éditeur… d'outils de débogage. C'est merveilleux, laisser moi vous expliquer pourquoi votre code est naze et a besoin d'un audit... Ah et au fait, je vends des audits. QUEL HASARD.

L'IA déplace-t-elle le travail vers le débogage ? J'ai mon avis et mon ressenti, et c'est pour ca que je suis aller voir une étude, pour avoir des faits concrêts.

Bon ben, je vais attendre hein.

Source en commentaire 👇

## 10-23 · Et si je lisais l'article ? (perso + IA)

J'ai fais le draft de ce post avec mon pote claude.

Il me trouve un article dont je veux parler, me prepare le bouzin et je reformule un peu.

Et soudain, épiphanie, une idée folle me traverse... et si je lisais l'article ?

Ouais je sais, c'est un peu dingo et so 2023.

Quoiqu'il en soit au final l'article est si biaisé que le terme a probablement été inventé pour lui.

Tout ca pour dire que j'ai trouvé un parallèle a la loi hofdater.

Il faut toujours vérifier ce que raconte ton llm mais quand tu sais qu'il toujours vérifier ce que raconte ton llm.

Au final je n'ai pas du tout parlé de l'article... nous parlerons une prochaine fois.

## 10-22 · PHP c'est mort (actualité, clivant ; record)

Php c'est mort, ca ne fait plus tourner tant de site web que ca.

Je crois que vous êtes en dehors de la réalité.

Cette chanson on l'entends toute l'année par ses plus grand détracteurs.

Et comme par hasard, on a deux failles qui apparaissent et tout d'un coup php c'est 70% du web.

Petit rictus obligé

## 10-21 · La crèche (perso)

Je suis président d'une crèche associative.

Une crèche à gestion parentale : ce sont les parents qui la gère avec 16 employés à plein temps. Et heureusement on a une directrice et un logiciel pour ca.

Il est nul. Vous savez, ces vieux modèles où le paiement de base se supplée à une politique de formation. Principe qui induit qu'une mauvaise UX amène à plus de formation.

Pourtant, les fonctionnalités sont cool et assez puissante. Mais c'est un enfer à utiliser.

Alors j'ai commencé à construire le mien.

Objectif : 3 features canonnissimes et un prix raisonnable.

ps: C'est sur invitation uniquement pour le moment, si tu veux une démo DM.

## 10-20 · Les tests, ça se paie (dirigeant, diptyque)

Les tests, ca se paient.

Mais à quoi bon payer des tautologies (je la sors de loin celle là) ?

Vos équipes sont à 1 prompt d'avoir une couverture à plus de 90% sur votre code. Pourquoi s'en priver ?

Parce que ca ne sert à rien. Quelle garantie avec vous réellement que vos tests, testent bien ce que ca doit tester ? Personnes ne va relire autant de test (pas des humains en tout cas).

On paye la prime et on est pas couvert.

Avec l'IA, la couverture est devenu un chiffre qu'on agite comme un drapeau pour annoncer que la codebase est saine.

Et pourtant, en audit c'est simple à vérifier, faites des tests de mutation sur votre code et regardez voir :)

## 10-20 · Les tests unitaires sont morts (dev, diptyque)

Les tests unitaires sont morts, vives les tests unitaires.

On en parle beaucoup en ce moment de ne plus faire de test unitaire via l'agentic. Soit disant ca ne résoud rien et ca ne produit pas du code de meilleur qualité.

Je suis plongé dans un état de semi dégout et de fascination. Qui a bien pu penser à une telle supercherie ?

C'est intéressant, parcequ'on le voit les tests que l'IA écrit, ou plutôt, on ne les voit pas vu qu'on ne les relis pas. On ne sait même s'ils testent ce qu'ils doivent tester. C'est vert, c'est mergeable, #yolo, après tout, pourquoi pas.

Dans le but d'avoir plsu confiance dans mes process IA j'expérimente un nouveau truc, une fois que la PR réalisée, je fais des mutation du code sur la core feature et je m'assure que ca ne passe pas. Ca fait maintenant partie de mon process de review. Chaque mutation, un test qui échoue.

## 10-19 · La dette technique (publié, après correction)

La dette technique, c'était un no-go permanent.
"Jamais de dette. On fait propre ou on ne fait pas."
Ce n'est plus un axiome, c'est une variable.
La dette, c'est un emprunt.
Tu gagnes du temps maintenant et tu paies plus tard, avec les intérêts.
La seule question qui compte : est-ce que le gain vaut le coût du remboursement ?
À une condition : la rembourser un jour.
Et avec l'IA, le calcul change.
Mais pas assez pour changer la réponse.
Avant, si tu créais de la dette sans la maîtriser, c'était ta faute.
Maintenant, c'est ton process IA qui est mal foutu.
Et ton process, c'est toujours ta faute.

## 10-18 · L'entretien tech idéal (perso)

J'aime bien imaginer mon entretien tech idéal.

Je n'en fais pas passer très souvent, mais quand c'est le cas c'est toujours à la dernière minute qu'on me prévient. Du coup, ben je suis prêt.

Et en ce moment ben ... c'est compliqué.

Je pense que je veux voir 3 choses :
- avoir envie de travailler avec le mec. Si c'est agréable tant mieux, mais le plus important c'est de pouvoir être en désaccord et de trouver une solution
- qu'il soit investit dans une forme d'actualités tech et de remise en question de méthodes
- qu'il soit capable de me parler des grands principes sans etre trop tech.

Et du coup aujourd'hui je pense que je ferais un entretien de 1h00 en mode blabla tech et démo + explication de son flow IA et de sa méthodo.

## 10-17 · Le cahier du « fait » (perso + outil)

J'ai toujours tracké ce que je fais.

Un cahier pour écrire non pas les taches à faire mais faites.

Ca m'aide a être satisfait a la fin de la journée et la moitié de mon stand up du lendemain déjà prêt (enfin quand j'en faisais).

J'ai toujours voulu le numériser, mais une flemme immense pour un usage trop niche.

Alors merci claude, merci le mcp qui me permet de tout tracer auto. Merci pour les autres fonctionnalités, les reunions, les taches recurrentes, les objectifs et le Tui (terminal ui, dans herdr .... banger).

C'est pas un truc a vendre, c'est beaucoup trop spécifique à ma façon de travailler, mais depuis je n'ai qu'un point d'entré pour tout etca m'allège le cerveau.

## 10-16 · La review, goulot de l'IA

Je suis d'accord avec moi même.

C'est marrant le bottleneck actuel de l'IA : LA REVIEW

Ce fameux processus de relecture plus ou moins approfondi du code produit par un humain/agent depuis le point de vue biaisé d'un autre humain/agent dont l'aboutissement fini fréquement par un débat philosophique sur la nécessité ou non d'être aussi tatillon ou je m'en foutiste par ces mêmes humain/agent.

Pour avancer, il va falloir se mettre d'accord pour de vrai, de facon transverse sur une équipe/entreprise/coeur de métier.

J'pense qu'on va y être pendant un bon moment.
