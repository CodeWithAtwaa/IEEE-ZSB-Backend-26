<x-layouts>

    <form method="POST" action="{{ route('submit') }}" class="flex flex-col items-center justify-center mt-2">
        @csrf
        @if (session('success'))
            <div class="bg-green-500 text-white p-4 rounded mb-4">
                {{ session('success') }}
            </div>
        @endif
        <p>Welcome Text</p>
        <textarea name="message" placeholder="Enter your message" name="message "
            class="border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500"></textarea>
        <button type="submit" class="bg-blue-900 text-white-50 p-2 m-2">Submit</button>
    </form>

    <div class="flex justify-center mt-4 align-center">
        {{ $ideas->links() }}
    </div>
    <table>
        <thead>
            <tr>
                <th>Message</th>
            </tr>
        </thead>
        <tbody>
            @foreach ($ideas as $idea)
                <tr>
                    <td>{{ $idea->message }}</td>
                </tr>
            @endforeach
            {{-- make paginate --}}
        </tbody>


    </table>
</x-layouts>
