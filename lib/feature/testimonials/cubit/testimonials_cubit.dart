import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'testimonials_state.dart';

class TestimonialsCubit extends Cubit<TestimonialsState> {
  TestimonialsCubit()
      : super(const TestimonialsState(
          testimonials: [
            Testimonial(
              name: 'محمد و فاطمة',
              event: 'فرح نوفمبر 2024',
              text: 'ابراهيم مبقاش بس مصور — ده فنان بيحس باللحظة. كل صورة حسينا فيها إحنا تاني مع بعض. التجربة كلها كانت راقية جداً من أول ما دخل لحد ما طلعنا.',
              initials: 'م.ف',
            ),
            Testimonial(
              name: 'أحمد و نور',
              event: 'فرح أكتوبر 2024',
              text: 'من أول ما دخلنا الكوشة لحد ما طلعنا، كان موجود في كل حتة. الصور جميلة جداً وبتحكي القصة كلها. الألبوم جه أحسن من توقعاتنا.',
              initials: 'أ.ن',
            ),
            Testimonial(
              name: 'كريم و ياسمين',
              event: 'فرح سبتمبر 2024',
              text: 'الألبوم جه أحسن من أي حاجة تخيلتها! شكراً ابراهيم على كل لحظة حلوة اتسجلت. موهبة حقيقية وشخص رائع التعامل معاه.',
              initials: 'ك.ي',
            ),
            Testimonial(
              name: 'عمر و سارة',
              event: 'فرح أغسطس 2024',
              text: 'التفاصيل الصغيرة اللي بيلتقطها ابراهيم هي الحاجة اللي بتفرقه عن غيره. موهبة حقيقية وبيحب اللي بيعمله وده بيظهر في كل صورة.',
              initials: 'ع.س',
            ),
            Testimonial(
              name: 'يوسف و منى',
              event: 'فرح يوليو 2024',
              text: 'باكدج الفيديو كان قمة! الريل اللي جه نزلناه على الانستا وعمل اتفاعل رهيب. كل حاجة اتسجلت بطريقة سينمائية رائعة.',
              initials: 'ي.م',
            ),
            Testimonial(
              name: 'طارق و ريهام',
              event: 'فرح يونيو 2024',
              text: 'من أول ما تعاملنا مع ابراهيم حسينا بالأمان. هو بيعرف يخلي الناس تحس بالراحة قدام الكاميرا وده أهم حاجة. شكراً على كل شيء.',
              initials: 'ط.ر',
            ),
          ],
        ));

  void addTestimonial(Testimonial testimonial) {
    final updated = [testimonial, ...state.testimonials];
    emit(state.copyWith(testimonials: updated));
  }
}
