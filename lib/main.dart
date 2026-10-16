import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

void main()=>runApp(const SandipApp());
const blue=Color(0xFF087CF0), gold=Color(0xFFFFC15A);

class SandipApp extends StatefulWidget { const SandipApp({super.key}); @override State<SandipApp> createState()=>_AppState(); }
class _AppState extends State<SandipApp>{
 ThemeMode mode=ThemeMode.light; bool logged=false;
 void theme()=>setState(()=>mode=mode==ThemeMode.light?ThemeMode.dark:ThemeMode.light);
 @override Widget build(BuildContext context){
  ThemeData make(Brightness b)=>ThemeData(useMaterial3:true,brightness:b,colorScheme:ColorScheme.fromSeed(seedColor:b==Brightness.dark?gold:blue,brightness:b),scaffoldBackgroundColor:b==Brightness.dark?const Color(0xFF071426):const Color(0xFFF5F8FC),cardTheme:CardThemeData(elevation:0,color:b==Brightness.dark?const Color(0xFF102238):Colors.white,margin:EdgeInsets.zero),inputDecorationTheme:InputDecorationTheme(filled:true,fillColor:b==Brightness.dark?const Color(0xFF0B1A2D):const Color(0xFFF7F9FC),border:OutlineInputBorder(borderRadius:BorderRadius.circular(15))));
  return MaterialApp(debugShowCheckedModeBanner:false,title:'Sandip Flute Learning',theme:make(Brightness.light),darkTheme:make(Brightness.dark),themeMode:mode,home:logged?Home(toggle:theme,dark:mode==ThemeMode.dark,logout:()=>setState(()=>logged=false)):Login(toggle:theme,dark:mode==ThemeMode.dark,login:()=>setState(()=>logged=true)));
 }
}
class Login extends StatefulWidget { final VoidCallback toggle,login; final bool dark; const Login({super.key,required this.toggle,required this.dark,required this.login}); @override State<Login> createState()=>_LoginState(); }
class _LoginState extends State<Login> with SingleTickerProviderStateMixin{
 final email=TextEditingController(),pass=TextEditingController(); bool signup=false,obscure=true; late AnimationController anim;
 @override void initState(){super.initState();anim=AnimationController(vsync:this,duration:const Duration(seconds:7))..repeat(reverse:true);}
 @override void dispose(){anim.dispose();email.dispose();pass.dispose();super.dispose();}
 @override Widget build(BuildContext context){final dark=widget.dark,accent=dark?gold:blue;return Scaffold(body:Stack(children:[
  Positioned.fill(child:DecoratedBox(decoration:BoxDecoration(gradient:LinearGradient(begin:Alignment.topCenter,end:Alignment.bottomCenter,colors:dark?[const Color(0xFF061225),const Color(0xFF102A48),const Color(0xFF071426)]:[const Color(0xFFEAF7FF),Colors.white,const Color(0xFFD9EDFF)])))),
  Positioned(right:-10,top:40,child:AnimatedBuilder(animation:anim,builder:(c,ch)=>Transform.rotate(angle:anim.value*.12,child:ch),child:Icon(Icons.music_note,size:130,color:accent.withOpacity(.15)))),
  SafeArea(child:ListView(padding:const EdgeInsets.fromLTRB(24,8,24,20),children:[
   Align(alignment:Alignment.topRight,child:IconButton(onPressed:widget.toggle,icon:Icon(dark?Icons.light_mode:Icons.dark_mode))),
   const SizedBox(height:8),
   Column(children:[Container(width:72,height:72,decoration:BoxDecoration(shape:BoxShape.circle,color:accent.withOpacity(.12),border:Border.all(color:accent.withOpacity(.35))),child:Icon(Icons.music_note,size:42,color:accent)),const SizedBox(height:8),Text('Sandip',style:TextStyle(fontSize:48,fontStyle:FontStyle.italic,fontWeight:FontWeight.w300,letterSpacing:-2,color:dark?Colors.white:const Color(0xFF102543))),Container(width:145,height:5,decoration:BoxDecoration(color:accent,borderRadius:BorderRadius.circular(8))),const SizedBox(height:10),const Text('F L U T E   L E A R N I N G',style:TextStyle(fontWeight:FontWeight.bold,letterSpacing:2,fontSize:12)),const SizedBox(height:5),Text('Feel the Music, Learn the Art',style:TextStyle(fontStyle:FontStyle.italic,color:Theme.of(context).colorScheme.onSurfaceVariant))]),
   const SizedBox(height:24),
   Card(shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(26)),child:Padding(padding:const EdgeInsets.all(20),child:Column(crossAxisAlignment:CrossAxisAlignment.stretch,children:[
    Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: () => setState(() => signup = false),
            child: Text(
              'Login',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: !signup ? accent : null,
              ),
            ),
          ),
        ),
        Expanded(
          child: TextButton(
            onPressed: () => setState(() => signup = true),
            child: Text(
              'Sign Up',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: signup ? accent : null,
              ),
            ),
          ),
        ),
      ],
    ),
    const SizedBox(height:10),TextField(controller:email,keyboardType:TextInputType.emailAddress,decoration:const InputDecoration(prefixIcon:Icon(Icons.mail_outline),hintText:'Email address')),const SizedBox(height:12),
    TextField(controller:pass,obscureText:obscure,decoration:InputDecoration(prefixIcon:const Icon(Icons.lock_outline),hintText:'Password',suffixIcon:IconButton(onPressed:()=>setState(()=>obscure=!obscure),icon:Icon(obscure?Icons.visibility_off:Icons.visibility)))),
    if(!signup)Align(alignment:Alignment.centerRight,child:TextButton(onPressed:()=>ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Password recovery will be connected later.'))),child:const Text('Forgot password?'))),
    const SizedBox(height:6),FilledButton.icon(style:FilledButton.styleFrom(backgroundColor:accent,foregroundColor:dark?const Color(0xFF102039):Colors.white,padding:const EdgeInsets.symmetric(vertical:16)),onPressed:(){if(email.text.trim().isEmpty||pass.text.isEmpty){ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Enter an email and password to preview the app.')));return;}widget.login();},icon:const Icon(Icons.arrow_forward),label:Text(signup?'Create account':'Login')),
    const SizedBox(height:18),Row(children:[const Expanded(child:Divider()),Padding(padding:const EdgeInsets.symmetric(horizontal:10),child:Text('OR CONTINUE WITH',style:Theme.of(context).textTheme.labelSmall)),const Expanded(child:Divider())]),const SizedBox(height:12),
    OutlinedButton.icon(onPressed:()=>ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Google sign-in will be configured later.'))),icon:const Icon(Icons.g_mobiledata,size:30),label:const Text('Continue with Google'),style:OutlinedButton.styleFrom(padding:const EdgeInsets.symmetric(vertical:12))),
    const SizedBox(height:12),Center(child:Text(signup?'Already have an account?':'New to Sandip?')),Center(child:TextButton(onPressed:()=>setState(()=>signup=!signup),child:Text(signup?'Login':'Create an Account',style:TextStyle(color:accent,fontWeight:FontWeight.bold))))
   ]))),
   const SizedBox(height:12),
   SizedBox(height:90,child:Stack(alignment:Alignment.center,children:[Positioned(left:8,bottom:0,child:Icon(Icons.landscape,size:120,color:accent.withOpacity(.15))),Positioned(left:35,bottom:0,child:Icon(Icons.person,size:75,color:dark?const Color(0xFF020914):const Color(0xFF24517B))),Positioned(left:75,bottom:31,child:Transform.rotate(angle:-.12,child:Container(width:54,height:5,decoration:BoxDecoration(color:gold,borderRadius:BorderRadius.circular(8))))),Positioned(right:50,bottom:25,child:Icon(Icons.music_note,size:30,color:gold))]))
  ]))
 ]));}
}
class Song{String title,category,level,notation;Song(this.title,this.category,this.level,this.notation);Map<String,dynamic> json()=>{'title':title,'category':category,'level':level,'notation':notation};factory Song.from(Map<String,dynamic> j)=>Song(j['title']??'',j['category']??'My Songs',j['level']??'Easy',j['notation']??'');}
final samples=<Song>[
 Song('Kesariya','Bollywood','Medium','Intro\nS  R  G  M | G  R  S  -\nS  R  G  M | P  M  G  -\n\nMukhda\nP  P  D  P | M  G  R  S'),
 Song('Tum Hi Ho','Bollywood','Medium','Intro\nS  R  G  M | G  R  S  -\nR  G  M  P | M  G  R  -'),
 Song('Vaishnav Jan To','Devotional','Easy','S  R  G  R | S  -  S  -\nR  G  M  G | R  -  -  -'),
 Song('Raga Yaman Practice','Classical','Beginner','Aroha\nN  R  G  M^  P  D  N  S\nAvaroha\nS  N  D  P  M^  G  R  S'),
 Song('Folk Melody Practice','Folk','Easy','S  S  R  G | R  S  -  -\nG  G  M  P | M  G  R  S')];
class Home extends StatefulWidget{final VoidCallback toggle,logout;final bool dark;const Home({super.key,required this.toggle,required this.dark,required this.logout});@override State<Home> createState()=>_HomeState();}
class _HomeState extends State<Home>{int tab=0;List<Song> songs=List.from(samples);Set<String> fav={};@override void initState(){super.initState();load();}Future<void> load()async{final p=await SharedPreferences.getInstance();final raw=p.getString('sandip_songs');if(raw!=null){try{final ss=(jsonDecode(raw) as List).map((e)=>Song.from(Map<String,dynamic>.from(e))).toList();if(mounted)setState(()=>songs=ss);}catch(_){}}}Future<void> save()async{final p=await SharedPreferences.getInstance();await p.setString('sandip_songs',jsonEncode(songs.map((s)=>s.json()).toList()));}
void open(Song s){Navigator.push(context,MaterialPageRoute(builder:(_)=>Detail(song:s,edit:()async{final u=await Navigator.push<Song>(context,MaterialPageRoute(builder:(_)=>Editor(song:s)));if(u!=null){setState(()=>songs[songs.indexWhere((x)=>x.title==s.title)]=u);save();}})));}
void create(){Navigator.push(context,MaterialPageRoute(builder:(_)=>Editor(onSave:(s){setState(()=>songs.add(s));save();setState(()=>tab=1);}))); }
@override Widget build(BuildContext context){final pages=<Widget>[dashboard(),listing('My Songs',songs),const SizedBox(),notifications(),profile()];return Scaffold(body:SafeArea(child:IndexedStack(index:tab,children:pages)),bottomNavigationBar:NavigationBar(selectedIndex:tab,onDestinationSelected:(v){if(v==2){create();return;}setState(()=>tab=v);},destinations:const [NavigationDestination(icon:Icon(Icons.home_outlined),label:'Home'),NavigationDestination(icon:Icon(Icons.library_music_outlined),label:'My Songs'),NavigationDestination(icon:Icon(Icons.add_circle_outline),label:'Add'),NavigationDestination(icon:Icon(Icons.notifications_none),label:'Alerts'),NavigationDestination(icon:Icon(Icons.person_outline),label:'Profile')]));}
Widget dashboard()=>ListView(padding:const EdgeInsets.all(18),children:[Row(children:[const CircleAvatar(child:Icon(Icons.music_note)),const SizedBox(width:12),const Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('Hello, Sandip 👋',style:TextStyle(fontSize:20,fontWeight:FontWeight.bold)),Text('Let’s play something beautiful today') ])),IconButton(onPressed:()=>setState(()=>tab=3),icon:const Icon(Icons.notifications_none))]),const SizedBox(height:18),Container(padding:const EdgeInsets.all(20),decoration:BoxDecoration(borderRadius:BorderRadius.circular(22),gradient:const LinearGradient(colors:[Color(0xFF176BB5),Color(0xFF0D2B4C)])),child:const Row(children:[Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('PRACTICE DAILY',style:TextStyle(color:gold,fontWeight:FontWeight.bold,letterSpacing:1.2)),SizedBox(height:8),Text('Improve your fluency',style:TextStyle(color:Colors.white,fontSize:21,fontWeight:FontWeight.bold)),Text('Small steps. Beautiful melodies.',style:TextStyle(color:Colors.white70))])),Icon(Icons.music_note,size:64,color:gold)])),const SizedBox(height:24),const Text('Categories',style:TextStyle(fontSize:21,fontWeight:FontWeight.bold)),const SizedBox(height:12),GridView.count(shrinkWrap:true,physics:const NeverScrollableScrollPhysics(),crossAxisCount:2,mainAxisSpacing:10,crossAxisSpacing:10,childAspectRatio:1.6,children:[('Bollywood',Icons.movie,Color(0xFFE78AA5)),('Classical',Icons.spa,Color(0xFF7C9EE8)),('Devotional',Icons.temple_hindu,Color(0xFFFFBE67)),('Folk',Icons.festival,Color(0xFF6BC5A2)),('Instrumental',Icons.piano,Color(0xFFB49AE8)),('Favorites',Icons.favorite,Color(0xFFEF7885))].map((c)=>InkWell(onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>listing(c.$1,c.$1=='Favorites'?songs.where((s)=>fav.contains(s.title)).toList():songs.where((s)=>s.category==c.$1).toList()))),child:Container(padding:const EdgeInsets.all(14),decoration:BoxDecoration(color:c.$3.withOpacity(.16),borderRadius:BorderRadius.circular(17),border:Border.all(color:c.$3.withOpacity(.4))),child:Column(crossAxisAlignment:CrossAxisAlignment.start,mainAxisAlignment:MainAxisAlignment.spaceBetween,children:[Icon(c.$2,color:c.$3,size:28),Text(c.$1,style:const TextStyle(fontWeight:FontWeight.bold)),const Text('Explore notation',style:TextStyle(fontSize:11))])))).toList()),const SizedBox(height:22),const Text('Recently added',style:TextStyle(fontSize:21,fontWeight:FontWeight.bold)),const SizedBox(height:10),...songs.take(4).map((s)=>Padding(padding:const EdgeInsets.only(bottom:8),child:tile(s)))]);
Widget tile(Song s)=>Card(child:ListTile(onTap:()=>open(s),leading:Container(width:45,height:45,decoration:BoxDecoration(color:blue.withOpacity(.12),borderRadius:BorderRadius.circular(12)),child:const Icon(Icons.music_note,color:blue)),title:Text(s.title,style:const TextStyle(fontWeight:FontWeight.bold)),subtitle:Text('${s.category} · ${s.level}'),trailing:const Icon(Icons.chevron_right)));
Widget listing(String title,List<Song> list)=>Scaffold(appBar:AppBar(title:Text(title)),body:list.isEmpty?const Center(child:Text('No songs yet. Tap Add to write notation.')):ListView.separated(padding:const EdgeInsets.all(16),itemCount:list.length,separatorBuilder:(_,__)=>const SizedBox(height:8),itemBuilder:(_,i)=>tile(list[i])));
Widget notifications() => Scaffold(
  appBar: AppBar(title: const Text('Notifications')),
  body: ListView(
    padding: const EdgeInsets.all(16),
    children: [
      Card(
        child: ListTile(
          leading: const Icon(Icons.music_note, color: blue),
          title: const Text('Your daily practice awaits'),
          subtitle: const Text('Spend 10 minutes on a melody today.'),
        ),
      ),
      Card(
        child: ListTile(
          leading: const Icon(Icons.tips_and_updates, color: gold),
          title: const Text('Practice tip'),
          subtitle: const Text('Start slowly and keep every note clear.'),
        ),
      ),
    ],
  ),
);
Widget profile() => Scaffold(
  appBar: AppBar(title: const Text('My Profile')),
  body: ListView(
    padding: const EdgeInsets.all(18),
    children: [
      const SizedBox(height: 10),
      const CircleAvatar(
        radius: 40,
        child: Icon(Icons.person, size: 45),
      ),
      const SizedBox(height: 12),
      const Center(
        child: Text(
          'Sandip',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      const Center(child: Text('Flute learner')),
      const SizedBox(height: 24),
      Card(
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.image_outlined),
              title: const Text('Import notation image'),
              subtitle: const Text('Choose image from gallery'),
              onTap: () async {
                final file = await ImagePicker().pickImage(
                  source: ImageSource.gallery,
                );
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      file == null
                          ? 'No image selected'
                          : 'Selected ${file.name}; recognition not included yet.',
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(
                widget.dark ? Icons.dark_mode : Icons.light_mode,
              ),
              title: const Text('Appearance'),
              subtitle: Text(widget.dark ? 'Dark mode' : 'Light mode'),
              trailing: Switch(
                value: widget.dark,
                onChanged: (_) => widget.toggle(),
              ),
            ),
            const ListTile(
              leading: Icon(Icons.admin_panel_settings_outlined),
              title: Text('Admin tools'),
              subtitle: Text('Demo only; secure admin access not configured'),
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Log out'),
              onTap: widget.logout,
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      const Text(
        'Sandip Flute Learning · Prototype',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey),
      ),
    ],
  ),
);
}
class Detail extends StatelessWidget{final Song song;final VoidCallback edit;const Detail({super.key,required this.song,required this.edit});@override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:Text(song.title),actions:[IconButton(onPressed:edit,icon:const Icon(Icons.edit))]),body:ListView(padding:const EdgeInsets.all(20),children:[Container(height:140,decoration:BoxDecoration(borderRadius:BorderRadius.circular(20),gradient:const LinearGradient(colors:[Color(0xFF0E3154),Color(0xFF227BB7)])),child:const Column(mainAxisAlignment:MainAxisAlignment.center,children:[Icon(Icons.music_note,size:50,color:gold),Text('FLUTE NOTATION',style:TextStyle(color:Colors.white,letterSpacing:2))])),const SizedBox(height:20),const Text('Notation',style:TextStyle(fontSize:22,fontWeight:FontWeight.bold)),const SizedBox(height:12),Container(padding:const EdgeInsets.all(18),decoration:BoxDecoration(color:Theme.of(context).cardTheme.color,borderRadius:BorderRadius.circular(18)),child:SelectableText(song.notation,style:const TextStyle(fontFamily:'monospace',fontSize:17,height:1.8,letterSpacing:1.2))),const SizedBox(height:16),FilledButton.icon(onPressed:edit,icon:const Icon(Icons.edit),label:const Text('Write / Edit Notation'))]));}
class Editor extends StatefulWidget{final Song? song;final ValueChanged<Song>? onSave;const Editor({super.key,this.song,this.onSave});@override State<Editor> createState()=>_EditorState();}
class _EditorState extends State<Editor>{
 late TextEditingController title,notation;late String category,level;String mode='Shuddha';final List<String> history=[];
 @override void initState(){super.initState();title=TextEditingController(text:widget.song?.title??'');notation=TextEditingController(text:widget.song?.notation??'');category=widget.song?.category??'Bollywood';level=widget.song?.level??'Easy';}
 @override void dispose(){title.dispose();notation.dispose();super.dispose();}
 void remember(){history.add(notation.text);if(history.length>60)history.removeAt(0);}
 void insert(String token){final value=notation.text;final sel=notation.selection;final start=sel.isValid?sel.start:value.length;final end=sel.isValid?sel.end:value.length;String prefix='';String suffix='';if(token==' '){if(start>0&&value[start-1]!=' '&&value[start-1]!='\n')prefix=' ';token='';}else if(token!='\n'&&token!='|'&&token!='||'&&token!='—'){if(start>0&&value[start-1]!=' '&&value[start-1]!='\n'&&value[start-1]!='|')prefix=' ';if(end<value.length&&value[end]!=' '&&value[end]!='\n'&&value[end]!='|')suffix=' ';}
 remember();final text=value.substring(0,start)+prefix+token+suffix+value.substring(end);final cursor=start+prefix.length+token.length+suffix.length;notation.value=TextEditingValue(text:text,selection:TextSelection.collapsed(offset:cursor));}
 String swara(String s){if(mode=='Komal'){switch(s){case 'Re':return 'r';case 'Ga':return 'g';case 'Dha':return 'd';case 'Ni':return 'n';default:return s=='Sa'?'S':s=='Ma'?'M':s=='Pa'?'P':s;}}return {'Sa':'S','Re':'R','Ga':'G','Ma':'M','Pa':'P','Dha':'D','Ni':'N'}[s]??s;}
 void undo(){if(history.isEmpty)return;notation.text=history.removeLast();notation.selection=TextSelection.collapsed(offset:notation.text.length);}
 void clear(){if(notation.text.isEmpty)return;remember();notation.clear();}
 void save(){if(title.text.trim().isEmpty||notation.text.trim().isEmpty){ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Enter a song title and notation.')));return;}final s=Song(title.text.trim(),category,level,notation.text.trim());if(widget.onSave!=null){widget.onSave!(s);Navigator.pop(context);}else{Navigator.pop(context,s);}}
 Widget keyButton(String label,String value,{Color? color})=>SizedBox(width:68,child:OutlinedButton(onPressed:()=>insert(value),style:OutlinedButton.styleFrom(padding:const EdgeInsets.symmetric(horizontal:5,vertical:13),side:BorderSide(color:color??blue.withOpacity(.35)),shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(12))),child:Text(label,textAlign:TextAlign.center,style:TextStyle(fontWeight:FontWeight.w700,color:color))));
 Widget special(String label,String value)=>ActionChip(label:Text(label),onPressed:()=>insert(value),avatar:const Icon(Icons.add,size:16));
 @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:Text(widget.song==null?'Write Notation':'Edit Notation'),actions:[TextButton(onPressed:save,child:const Text('Save'))]),body:ListView(padding:const EdgeInsets.all(16),children:[
 const Text('Song title',style:TextStyle(fontWeight:FontWeight.w600)),const SizedBox(height:7),TextField(controller:title,decoration:const InputDecoration(hintText:'My flute melody')),const SizedBox(height:14),
 Row(children:[const Expanded(child:Text('Category',style:TextStyle(fontWeight:FontWeight.w600))),const SizedBox(width:12),Expanded(child:DropdownButtonFormField<String>(value:category,items:['Bollywood','Classical','Devotional','Folk','Instrumental','My Songs'].map((s)=>DropdownMenuItem(value:s,child:Text(s))).toList(),onChanged:(v)=>setState(()=>category=v??category)))]),const SizedBox(height:12),
 Row(children:[const Expanded(child:Text('Difficulty',style:TextStyle(fontWeight:FontWeight.w600))),const SizedBox(width:12),Expanded(child:DropdownButtonFormField<String>(value:level,items:['Beginner','Easy','Medium','Advanced'].map((s)=>DropdownMenuItem(value:s,child:Text(s))).toList(),onChanged:(v)=>setState(()=>level=v??level)))]),const SizedBox(height:20),
 Container(padding:const EdgeInsets.all(14),decoration:BoxDecoration(color:Theme.of(context).cardTheme.color,borderRadius:BorderRadius.circular(18),border:Border.all(color:blue.withOpacity(.25))),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[const Text('INDIAN SWARA KEYBOARD',style:TextStyle(fontWeight:FontWeight.w800,letterSpacing:1.1)),const SizedBox(height:4),Text('Tap a swara to insert it into your notation',style:TextStyle(color:Theme.of(context).hintColor,fontSize:12)),const SizedBox(height:12),Row(children:[Expanded(child:ChoiceChip(label:const SizedBox(width:90,child:Center(child:Text('Shuddha'))),selected:mode=='Shuddha',onSelected:(_)=>setState(()=>mode='Shuddha'))),const SizedBox(width:8),Expanded(child:ChoiceChip(label:const SizedBox(width:90,child:Center(child:Text('Komal'))),selected:mode=='Komal',onSelected:(_)=>setState(()=>mode='Komal')))]),const SizedBox(height:12),Wrap(spacing:5,runSpacing:5,children:['Sa','Re','Ga','Ma','Pa','Dha','Ni'].map((s)=>keyButton(s,swara(s),color:mode=='Komal'&&['Re','Ga','Dha','Ni'].contains(s)?const Color(0xFFB45309):null)).toList()),const SizedBox(height:12),const Text('SPECIAL NOTES',style:TextStyle(fontWeight:FontWeight.w700,fontSize:12,letterSpacing:.8)),const SizedBox(height:8),Wrap(spacing:6,runSpacing:2,children:[special('Tivra Ma','M^'),special('High S′',"S'"),special('High R′',"R'"),special('Low Ṣ','S.'),special('Low P̣','P.'),special('Pause','-'),special('Long pause','—'),special('Bar |','|'),special('Double bar ‖','||'),special('Space',' '),special('New line','\n')]),const SizedBox(height:8),Text('Komal mode changes Re, Ga, Dha and Ni. Sa and Pa remain fixed; Ma is shuddha unless you tap Tivra Ma.',style:TextStyle(fontSize:12,color:Theme.of(context).hintColor))])),const SizedBox(height:16),
 Row(children:[const Expanded(child:Text('SONG FLUTE NOTES SHEET',style:TextStyle(fontWeight:FontWeight.w800,letterSpacing:.7))),IconButton(tooltip:'Undo',onPressed:history.isEmpty?null:undo,icon:const Icon(Icons.undo)),IconButton(tooltip:'Clear notation',onPressed:clear,icon:const Icon(Icons.delete_outline))]),TextField(controller:notation,minLines:8,maxLines:16,keyboardType:TextInputType.multiline,decoration:const InputDecoration(hintText:'Your flute notation appears here…\n\nS R G M | G R S -\nP D N S′',alignLabelWithHint:true,border:OutlineInputBorder()),style:const TextStyle(fontFamily:'monospace',fontSize:17,height:1.8,letterSpacing:.8)),const SizedBox(height:10),Wrap(spacing:8,runSpacing:4,children:[OutlinedButton.icon(onPressed:undo,icon:const Icon(Icons.undo),label:const Text('Undo')),OutlinedButton.icon(onPressed:clear,icon:const Icon(Icons.delete_outline),label:const Text('Clear')),OutlinedButton.icon(onPressed:()=>Clipboard.setData(ClipboardData(text:notation.text)).then((_){if(mounted)ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Notation copied.')));}),icon:const Icon(Icons.copy),label:const Text('Copy'))]),const SizedBox(height:14),FilledButton.icon(onPressed:save,icon:const Icon(Icons.save),label:const Text('Save notation'))]));
}
