#include <jni.h>
#include <string>
#include <android/log.h>

// https://stackoverflow.com/a/53154574
#define LOGI(...) ((void)__android_log_print(ANDROID_LOG_INFO, "native-lib", __VA_ARGS__))
#define LOGE(...) ((void)__android_log_print(ANDROID_LOG_ERROR, "native-lib", __VA_ARGS__))

extern "C" void play_music_func(JNIEnv *env, jobject jo, char *input, int metronome);
extern "C" int string_check(char *input);

void invalid_input(JNIEnv *env, jobject object) {
    jclass  clazz = env->GetObjectClass(object);
    if (clazz == nullptr) {
        LOGE("Failed to get MainActivity class");
        return;
    }

    // Get the method ID of the playNote method
    jmethodID invalidInputMethod = env->GetMethodID(clazz, "invalidInput", "()V");
    if (invalidInputMethod == nullptr) {
        LOGE("Failed to get invalidInput method ID");
        return;
    }
    env->CallVoidMethod(object, invalidInputMethod);
}

/*
 * expand function ensures that the length of input string is
 * a multiple of 16. if it's not, it adds 'b' character to the end of
 * string until the length of the string become appropriate.
 * */
char *expand(const char *input) {
    int len = (int)strlen(input);
    int r = len % 16;


    // check if the string has appropriate length
    if (r == 0) {
        return strdup(input);
    }

    LOGI("expanding");
    // we should expand it
    char *result = (char*) malloc((len + 16 - r + 1) * sizeof(char));
    strcpy(result, input);
    memset(result + len, 'b', 16-r);
    result[len + 16 - r] = '\0';
    return result;
}

extern "C" JNIEXPORT void JNICALL Java_com_example_mixzarb_MainActivity_playMusic(
        JNIEnv *env,
        jobject object,
        jstring input,
        int metronome
        ) {

    if (input == nullptr) {
        LOGE("input is null");
        return;
    }

    const char *input_str = env->GetStringUTFChars(input, JNI_FALSE);
    if (input_str == nullptr) {
        LOGE("input is null");
        return;
    }

    char *expanded = expand(input_str);
    env->ReleaseStringUTFChars(input, input_str);
    LOGI("the input is: %s, %d", expanded, strlen(expanded));

    int notValid = string_check(expanded);

    LOGI("end of validation");

    // if input is not valid
    if (notValid) {
        invalid_input(env, object);
        LOGE("Invalid input: %d", notValid);
        return;
    }

    LOGI("input is valid");


    play_music_func(env, object, expanded, metronome);
    LOGI("end of function");

    free(expanded);

    LOGI("Returning from JNI function");
}



extern "C" JNIEXPORT jstring JNICALL
Java_com_example_mixzarb_MainActivity_stringFromJNI(
        JNIEnv* env,
        jobject /* this */) {
    std::string hello = "Hello from C++";
    return env->NewStringUTF(hello.c_str());
}

void callJavaPlayNote(JNIEnv *env, jobject object, const char *note) {
    // Get the class of the object (MainActivity)
    jclass clazz = env->GetObjectClass(object);
    if (clazz == nullptr) {
        LOGE("Failed to get MainActivity class");
        return;
    }

    // Get the method ID of the playNote method
    jmethodID playNoteMethod = env->GetMethodID(clazz, "playNote", "(Ljava/lang/String;)V");
    if (playNoteMethod == nullptr) {
        LOGE("Failed to get playNote method ID");
        return;
    }

    // Create a Java string from the note
    jstring javaNote = env->NewStringUTF(note);
    if (javaNote == nullptr) {
        LOGE("Failed to create Java string");
        return;
    }

    // Call the playNote method
    env->CallVoidMethod(object, playNoteMethod, javaNote);

    // Release the Java string
    env->DeleteLocalRef(javaNote);
}

extern "C" void play_note_do(JNIEnv *env, jobject jo) {
    LOGI("play_note_do");
    callJavaPlayNote(env, jo, "do");
}

extern "C" void play_note_re(JNIEnv *env, jobject jo) {
    LOGI("play_note_re");
    callJavaPlayNote(env, jo, "re");
}

extern "C" void play_note_mi(JNIEnv *env, jobject jo) {
    LOGI("play_note_mi");
    callJavaPlayNote(env, jo, "mi");
}

extern "C" void play_note_fa(JNIEnv *env, jobject jo) {
    LOGI("play_note_fa");
    callJavaPlayNote(env, jo, "fa");
}

extern "C" void play_note_sol(JNIEnv *env, jobject jo) {
    LOGI("play_note_sol");
    callJavaPlayNote(env, jo, "sol");
}

extern "C" void play_note_la(JNIEnv *env, jobject jo) {
    LOGI("play_note_la");
    callJavaPlayNote(env, jo, "la");
}

extern "C" void play_note_ti(JNIEnv *env, jobject jo) {
    LOGI("play_note_ti");
    callJavaPlayNote(env, jo, "ti");
}

// for test purposes
extern "C" void Java_com_example_mixzarb_MainActivity_playOneNoteNTime(JNIEnv *env, jobject jo, jint n) {
    int t = n;
    char i[] = {'d'};
    while (t--) {
        play_music_func(env, jo, i, 100);
    }
}
