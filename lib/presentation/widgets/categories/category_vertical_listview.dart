import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_dely/aplication/providers/categoria/category_provider.dart';
import 'package:go_dely/config/router/app_router.dart';
import 'package:go_dely/domain/category/category.dart';
import 'package:go_router/go_router.dart';

class CategoryVerticalListView extends StatefulWidget {

  final List<Category> categorias;
  //final VoidCallback? loadNextPage;
  //const CategoryVerticalListView({super.key, this.title, this.descripcion, this.loadNextPage});
  const CategoryVerticalListView({super.key, required this.categorias});

  @override
  State<CategoryVerticalListView> createState() => _CategoryVerticalListViewState();
}



class _CategoryVerticalListViewState extends State<CategoryVerticalListView> {

  final scrollController = ScrollController();

  /*@override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if( widget.loadNextPage == null) return;
      if( (scrollController.position.pixels + 200) >= scrollController.position.maxScrollExtent ){
        widget.loadNextPage!();
      }
    },);
  }*/

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:680,
      child: Column(
        children: [

          const SizedBox(height: 5,),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: widget.categorias.length,
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return _SlideCategorias(categoria: widget.categorias[index]);
              },
            ),
          )

        ],
      ),
    );
  }
}

class _SlideCategorias extends ConsumerStatefulWidget {
  
  
  final Category categoria;
  

  const _SlideCategorias({required this.categoria});

  @override
  ConsumerState<_SlideCategorias> createState() => _SlideCategoriasState();
}

class _SlideCategoriasState extends ConsumerState<_SlideCategorias> {
  @override
  Widget build(BuildContext context) {

    final textStyles = Theme.of(context).textTheme;
    final titleStyle =  Theme.of(context).textTheme.titleLarge;

    return Padding(
      padding: const EdgeInsets.all(3),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),        
          border: Border.all(color: const Color.fromARGB(136, 186, 186, 186)),
          shape: BoxShape.rectangle,
        ),
        child: ListTile(
      title: SizedBox(
              child: Row(
                children: [
                  const SizedBox(width: 5,),
                  Text(
                    widget.categoria.name, 
                    
                    style: titleStyle,
                  ),
                  const SizedBox(width: 5,),
                ],
              ),
            ),
          onTap: () {
            ref.read(currentCategory.notifier).update((state) => widget.categoria.id,);
            context.push('/categoryView');
          },
        )
      
      
      
      
        /*Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            SizedBox(
              child: Row(
                children: [
                  const SizedBox(width: 5,),
                  Text(
                    categorias.name, 
                    
                    style: titleStyle,
                  ),
                  const SizedBox(width: 5,),
                ],
              ),
            ),
      
      
            SizedBox(
              child: Row( 
                children: [
                  const SizedBox(width: 5,),
                  Text(
                    categorias.descripcion, 
                    style: textStyles.bodyLarge,
                  ),
                  const SizedBox(width: 5,), 
                  
                ],
              ),
            )
      
      
      
      
        ]),*/
      ),
    );
  }
}